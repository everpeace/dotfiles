export AWS_DEFAULT_REGION=ap-northeast-1

function auth_aws_session(){
  local sts_profile=${1}
  if [ "z${sts_profile}" = "z" ]; then
    echo "usage: auth_aws_session <sts_profile> [mfa_token]";
    return 1;
  fi
  local token_code=${2}
  [ "z${2}" = "z" ] && echo -n "MFA token: " && read token_code
  local mfa_serial=$(aws configure --profile ${sts_profile} get mfa_serial)

  local region=${3:-ap-northeast-1}

  local OUTPUT_TMP_FILE=$(mktemp -d -t auth_aws_session.XXXXXXXX)/aws_output
  trap 'rm -f ${OUTPUT_TMP_FILE}; exit $1' 1 2 3 15

  aws --profile ${sts_profile} sts get-session-token --serial-number ${mfa_serial} --token-code ${token_code} > ${OUTPUT_TMP_FILE} && echo "session token successfully acquired."
  [ $? -gt 0 ] && echo "error." >&2 && return 1

  local key_id=$(cat ${OUTPUT_TMP_FILE} | jq -r '.Credentials.AccessKeyId')
  local secret_access_key=$(cat ${OUTPUT_TMP_FILE} | jq -r '.Credentials.SecretAccessKey')
  local session_token=$(cat ${OUTPUT_TMP_FILE} | jq -r '.Credentials.SessionToken')
  local expiration=$(cat ${OUTPUT_TMP_FILE} | jq -r '.Credentials.Expiration')
  echo "expiration: ${expiration}" >&2
  export AWS_ACCESS_KEY_ID=${key_id} && echo 'export AWS_ACCESS_KEY_ID=...'
  export AWS_SECRET_ACCESS_KEY=${secret_access_key} && echo 'export AWS_SECRET_ACCESS_KEY=...'
  export AWS_SESSION_TOKEN=${session_token} && echo 'export AWS_SESSION_TOKEN=...'
  export AWS_DEFAULT_REGION=${region} && echo "export AWS_DEFAULT_REGION=${AWS_DEFAULT_REGION}"

  rm -f ${OUTPUT_TMP_FILE}
}

function unauth_aws() {
  set -x
  unset AWS_ACCESS_KEY_ID
  unset AWS_SECRET_ACCESS_KEY
  unset AWS_SESSION_TOKEN
  unset AWS_DEFAULT_REGION
  export | grep AWS_
  set +x
}