export ZPLUG_HOME=/usr/local/opt/zplug
source $ZPLUG_HOME/init.zsh

# profiler
# zmodload zsh/zprof

# zplug itself
zplug 'zplug/zplug', hook-build:'zplug --self-manage'

#
# Prezto
# 
zplug "sorin-ionescu/prezto" #, \
  # use:"init.zsh", \
  # hook-build:"ln -s $ZPLUG_HOME/repos/sorin-ionescu/prezto ~/.zprezto"

zplug "modules/environment", from:prezto
zplug "modules/terminal", from:prezto
zplug "modules/editor", from:prezto
zplug "modules/history", from:prezto
zplug "modules/directory", from:prezto
zplug "modules/spectrum", from:prezto
zplug "modules/utility", from:prezto
zplug "modules/completion", from:prezto
# zplug "modules/contrib-prompt", from:prezto
# zplug "modules/prompt", from:prezto
zplug "modules/homebrew", from:prezto
zplug "modules/ruby", from:prezto
zplug "modules/python", from:prezto
zplug "modules/autosuggestions", from:prezto
zplug "modules/directory", from:prezto
# zplug "modules/fasd", from:prezto
# zplug "modules/gnu-utility", from:prezto
zplug "modules/git", from:prezto
zplug "modules/history-substring-seach", from:prezto
zplug "modules/tmux", from:prezto
zplug "modules/syntax-highlighting", from:prezto

# pretzo configuration

zstyle ':prezto:module:python:virtualenv' auto-switch 'yes'
zstyle ':prezto:module:tmux:auto-start' local 'yes'

zstyle ':prezto:module:syntax-highlighting' color 'yes'
zstyle ':prezto:module:syntax-highlighting' highlighters \
  'main' \
  'brackets' \
  'pattern' \
  'line' \
  'cursor' \
  'root'
# END: Prezto

#
# oh-my-zsh
#
zplug "plugins/autojump", from:oh-my-zsh
zplug "plugins/kubectl", from:oh-my-zsh

# END: oh-my-zsh

#
# zsh plugins
#

# powerline
. /usr/local/lib/python2.7/site-packages/powerline/bindings/zsh/powerline.zsh

# END: zsh plugins

# Can manage local plugins
mkdir -p ~/.zsh
zplug "~/.zsh", from:local

if ! zplug check --verbose; then
  printf 'Install? [y/N]: '
  if read -q; then
    echo; zplug install
  fi
fi
zplug load

# Language Setting
export LANG=ja_JP.UTF-8
export LC_ALL=${LANG}
export LESSCHARSET=utf-8
export LESS="-R"
alias log='>&2 echo \[.zshrc\] '

SSHUTTLE_PID_PATH=${SSHUTTLE_PID_PATH:-/tmp/sshuttle-office.pid}

# gitsshm
DOTFILE_DIR="$(readlink "${HOME}/.bash_profile" | xargs dirname)"
log configuring gitsshm
alias gitsshm="source ${DOTFILE_DIR}/gitsshm/gitsshm"
gitsshm everpeace_github


export HOMEBREW_CASK_OPTS="--appdir=/Applications"
if [ -f /usr/local/bin/brew ]; then
  brew_list_cache=$(brew list -1)
  brew_prefix=$(brew --prefix)

  is_installed(){
    if [ "$(echo "$brew_list_cache" |grep -c "^$1$")" = "1" ]; then
      return 0
    else
      return 1
    fi
  }

  if is_installed go; then
    log exporting GOROOT, GOPATH and PATH.
    export GOROOT=$brew_prefix/opt/go/libexec
    export GOPATH=${HOME}/go
    export PATH=${PATH}:${GOROOT}/bin:${GOPATH}/bin
  fi

  if is_installed direnv; then
    log activating direnv
    eval "$(direnv hook zsh)"
  fi

  if is_installed stern; then
    log activating stern completion
    source <(stern --completion=zsh)
  fi

  if is_installed gpg; then
    log setting up GPG_TTY
    export GPG_TTY=$(tty)
  fi
fi


## gp* : ghq + ghs + peco utilities
function gpi(){
  [ "$#" -eq 0 ] && echo "Usage : gpi QUERY" && return 1
  ghs "$@" | peco | awk '{print $1}' | ghq import
}

function gpr(){
  [ "$#" -eq 0 ] && echo "Usage : gpi QUERY" && return 1
  ghq list -p "$@" | peco | xargs rm -r
}

function gpcd(){
  [ "$#" -eq 0 ] && echo "Usage : gpcd QUERY" && return 1
  local full_path
  full_path=$(ghq list -p -e "$(ghq list "$@" | peco | awk '{print $1}')")
  cd "$full_path"
}

function gwt() {
  local GIT_CDUP_DIR=`git rev-parse --show-cdup`
  mkdir -p ${GIT_CDUP_DIR}git-worktrees
  git worktree add ${GIT_CDUP_DIR}git-worktrees/$1 $1
}

if [ -e "/usr/local/Caskroom/google-cloud-sdk" ]; then
  log activating and configuring google-cloud-sdk
  # The next line updates PATH for the Google Cloud SDK.
  source '/usr/local/Caskroom/google-cloud-sdk/latest/google-cloud-sdk/path.zsh.inc'

  # The next line enables shell command completion for gcloud.
  source '/usr/local/Caskroom/google-cloud-sdk/latest/google-cloud-sdk/completion.zsh.inc'
fi

# # path to the DCOS CLI binary
# if [[ "$PATH" != *"${HOME}/dcos/bin"* ]];
#   then export PATH=$PATH:${HOME}/dcos/bin;
# fi

# # path to the DCOS CLI binary
# if [[ "$PATH" != *"${HOME}/Desktop/dcos/bin"* ]];
#   then export PATH=$PATH:${HOME}/Desktop/dcos/bin;
# fi

# Microsoft R Open
if [ -e /Applications/Microsoft\ R\ Open.app/ ]; then
  log exporting RSTUDIO_WITH_R with Microsoft R Open
  export RSTUDIO_WHICH_R=/Applications/Microsoft\ R\ Open.app/Contents/MacOS/Microsoft\ R\ Open
fi
alias RStudio='open -a RStudio'

if [ -e /usr/local/bin/helm ]; then
  log activating helm zsh completion
  source <(helm completion zsh)
fi

function auth_aws() {
  key_id="$(1p_pw "awsapi|$1|$2|KEY_ID")"
  export AWS_ACCESS_KEY_ID=${key_id}
  echo export AWS_ACCESS_KEY_ID=...${key_id:(-5)}
  secret="$(1p_pw "awsapi|$1|$2|SECRET")"
  export AWS_SECRET_ACCESS_KEY=${secret}
  echo export AWS_SECRET_ACCESS_KEY=...${secret:(-5)}

  # read -sp "AWS_DEFAULT_REGION[ap-northeast-1]: " region
  # tty -s && echo
  region="$3"
  if [ "${region}" = "" ]; then
    region=ap-northeast-1
  fi
  export AWS_DEFAULT_REGION=${region}
  echo export AWS_DEFAULT_REGION=${region}
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

function 1p_pw() {
  1p_pw_copy "$*"
  echo "$(pbpaste)"
}

function 1p_pw_copy() {
  script=$(cat <<EOS
on run argv
  open location "x-onepassword-helper://search/"
  delay 0.5
  tell application "System Events" to tell process "1Password mini"
    keystroke argv
    delay 3
    set frontmost to true
    key code 124
    delay 0.5
    key code 36
  end tell
end run
EOS
)
  echo | pbcopy
  osascript -e "$script" "$*"
  sleep 0.5
}

function 1p_keypair_copy() {
  1p_keypair $@ | pbcopy
}

function 1p_keypair() {
  script=$(cat <<EOS
on run argv
   open location "x-onepassword-helper://search/"
  delay 0.5
  tell application "System Events" to tell process "1Password mini"
    keystroke argv
    delay 2
    set frontmost to true
    key code 124
    delay 0.5
    key code 125
    delay 0.2
    key code 36
  end tell
end run
EOS
)
  echo | pbcopy
  osascript -e "$script" "awskeypair|$1|$2"
  sleep 0.5
  _HEADER="-----BEGIN RSA PRIVATE KEY-----"
  _FOOTER="-----END RSA PRIVATE KEY-----"
  body=$(echo $(pbpaste) | sed -e "s/${_HEADER} //g" -e "s/ ${_FOOTER}//g" | ruby -pe 'gsub(/ /,"\r\n")')
  echo -n -e "${_HEADER}\r\n${body}\r\n${_FOOTER}"
}

# yaml to json
function yaml2json () {
 ruby -r yaml -r json -e 'puts YAML.load($stdin.read).to_json'
}


#sshconfig switcher
ssh_config_switch() {
  local mode=$1
  if [ -e $HOME/.ssh/config_$mode ]; then
    ln -fs $HOME/.ssh/config_$mode $HOME/.ssh/config
    ls -l $HOME/.ssh/config
  else
    echo "# Current ssh config status"
    ls -l $HOME/.ssh/config
    echo ""
    echo "# Supported ssh configs"
    ls -l $HOME/.ssh/config_*
  fi
}
export GITHUB_TOKEN=c0af7aa55b4d1fd9a22c573109c93b92a5d9a56c
export PFKUBE_DEFAULT_DOCKER_REGISTRY=harbor.pfn.io/user-omura
export PFKUBE_DOCKER_ALLOWED_RUNTIME_UID=2192
export PATH=/Users/everpeace/github_pfidev_jp/Cluster/inventory/bin:${PATH}

function sshuttle-office() {
    args=()
    for host in prometheus.pfn.io grafana.pfn.io jenkins.preferred.jp harbor.pfn.io dex.k8s.pfn.io s3.console.aws.amazon.com ap-northeast-1.console.aws.amazon.com deepmux-dashboard.pfn.io kubernetes-dashboard.pfn.io jenkins-cluster.pfn.io pypi.pfn.io api.aws-201906.k8s.pfn.io api.aws.k8s.pfn.io; do
        echo -n "$host: "
        for ip in $(dig +short $host | grep -E '^[0-9\.]+$' | xargs -I{} echo {}/32); do
            args+=($ip)
            echo -n "$ip "
        done
        echo ""
    done
    # aws service ip ranges
    echo -n "AWS public ip ranges: "
    for cidr in $(curl -s https://ip-ranges.amazonaws.com/ip-ranges.json | jq -r '.prefixes[] | select(.region == "ap-northeast-1") | .ip_prefix '); do
      args+=($cidr)
      echo -n "$cidr "
    done
    echo ""
    # echo "${args[@]}"
    sshuttle -D --pidfile $SSHUTTLE_PID_PATH -v -r office.pfidev.jp 172.28.0.0/16 10.16.3.74/32 "${args[@]}"
}

function sshuttle-stop() {
    kill $(cat $SSHUTTLE_PID_PATH)
}

function gi() { curl -sL gitignore.io/api/$@ ;}


function aws_mk_session_profile(){
  local sts_profile=${1}
  if [ "z${sts_profile}" = "z" ]; then
    echo "usage: aws_mk_session_profile <sts_profile> [mfa_token] [output_pfrofile]";
    return 1;
  fi
  local token_code=${2}
  [ "z${2}" = "z" ] && echo -n "MFA token: " && read token_code
  local output_profile=${3:-mfa-${sts_profile}}
  local mfa_serial=$(aws configure --profile ${sts_profile} get mfa_serial)
  local region=$(aws configure --profile ${sts_profile} get region)
  region=${region:-ap-northeast-1}

  OUTPUT_TMP_FILE=$(mktemp)
  trap 'rm -f ${OUTPUT_TMP_FILE}; exit $1' 1 2 3 15

  aws --profile ${sts_profile} sts get-session-token --serial-number ${mfa_serial} --token-code ${token_code} > ${OUTPUT_TMP_FILE} && echo "session token successfully acquired."
  [ $? -gt 0 ] && echo "error." >&2 && return 1

  local key_id=$(cat ${OUTPUT_TMP_FILE} | jq -r '.Credentials.AccessKeyId')
  local secret_access_key=$(cat ${OUTPUT_TMP_FILE} | jq -r '.Credentials.SecretAccessKey')
  local session_token=$(cat ${OUTPUT_TMP_FILE} | jq -r '.Credentials.SessionToken')
  local expiration=$(cat ${OUTPUT_TMP_FILE} | jq -r '.Credentials.Expiration')
  echo "expiration: ${expiration}" >&2
  aws configure --profile ${output_profile} set aws_access_key_id ${key_id}
  aws configure --profile ${output_profile} set aws_secret_access_key ${secret_access_key}
  aws configure --profile ${output_profile} set region ${region}
  aws configure --profile ${output_profile} set aws_session_token ${session_token}
  aws configure --profile ${output_profile} list 1>&2
  echo ${output_profile}
  rm -f ${OUTPUT_TMP_FILE}
}

function auth_aws_session(){
  local sts_profile=${1}
  if [ "z${sts_profile}" = "z" ]; then
    echo "usage: aws_mk_session <sts_profile> [mfa_token]";
    return 1;
  fi
  local token_code=${2}
  [ "z${2}" = "z" ] && echo -n "MFA token: " && read token_code
  local mfa_serial=$(aws configure --profile ${sts_profile} get mfa_serial)

  OUTPUT_TMP_FILE=$(mktemp)
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

  rm -f ${OUTPUT_TMP_FILE}
}

# krew
[ -e ${KREW_ROOT:-$HOME/.krew}/bin ] && log add krew to PATH && export PATH="${KREW_ROOT:-$HOME/.krew}/bin:$PATH"
