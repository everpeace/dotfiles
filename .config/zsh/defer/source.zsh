#
# Git utilities
#
function ghi {
  [ "$#" -eq 0 ] && echo "Usage : gpi QUERY" && return 1
  ( 
    ghs -k true -t $(gh auth token -h github.com) "$@" | sed -e 's/^/github.com\t/';
  ) | peco | awk '{print "https://"$1"/"$2".git"}' | ghq get
}

function g {
  # [ "$#" -eq 0 ] && echo "Usage : ghqcd QUERY" && return 1
  local full_path
  full_path=$(ghq list -p -e "$(ghq list "$@" | peco | awk '{print $1}')")
  cd "$full_path"
}

function grt {
  local _root_dir="$(git rev-parse --show-toplevel 2>/dev/null)"
  if [[ $? -gt 0 ]]; then
    >&2 echo 'Not a Git repo!'
    exit 1
  fi
  local _pwd=$(pwd)
  if [[ $_pwd = $_root_dir ]]; then
    # Handle submodules:
    # If parent dir is also managed under Git then we are in a submodule.
    # If so, cd to nearest Git parent project.
    _root_dir="$(git -C $(dirname $_pwd) rev-parse --show-toplevel 2>/dev/null)"
    if [[ $? -gt 0 ]]; then
      echo "Already at Git repo root."
      return 0
    fi
  fi
  # Make `cd -` work.
  OLDPWD=$_pwd
  echo "Git repo root: $_root_dir"
  cd $_root_dir
}

#
# Tools setup
#
# direnv
eval "$(direnv hook zsh)"

# gcloud (遅延ロード)
if [[ -n $HOMEBREW_PREFIX ]]; then
  _gcloud_lazy() {
    local inc="$HOMEBREW_PREFIX/Caskroom/google-cloud-sdk/latest/google-cloud-sdk/completion.zsh.inc"
    [[ -r $inc ]] && source "$inc"
    unfunction _gcloud_lazy
  }
  compdef _gcloud_lazy gcloud
fi

# kubesess
[ -f "${HOMEBREW_PREFIX}/share/zsh/site-functions/kubesess.sh" ] && source ${HOMEBREW_PREFIX}/share/zsh/site-functions/kubesess.sh

# ssh-agent-multiplexer
[[ ! -v SSH_CONNECTION ]] && export SSH_AUTH_SOCK="$(ssh-agent-multiplexer config print | grep '^listen' |cut -d'"' -f 2)"
