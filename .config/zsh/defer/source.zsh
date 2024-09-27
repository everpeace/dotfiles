#
# Generic utilities
#
function quietly {
    "$@" >/dev/null 2>&1
}

#
# Git utilities
#
function ghi {
  [ "$#" -eq 0 ] && echo "Usage : gpi QUERY" && return 1
  ghs -k true -t $(gh auth token -h github.com) "$@" | peco | awk '{print $1}' | ghq get -p
}

function g {
  # [ "$#" -eq 0 ] && echo "Usage : ghqcd QUERY" && return 1
  local full_path
  full_path=$(ghq list -p -e "$(ghq list "$@" | peco | awk '{print $1}')")
  cd "$full_path"
}

function groot {
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
# Completions
#
quietly type docker && source <(docker completion zsh)
quietly check stern && source <(stern --completion=zsh)
quietly check helm && source <(helm completion zsh)
quietly check rye && source <(rye self completion -s zsh)

#
# Tools setup
#
# direnv
eval "$(direnv hook zsh)"

# gcloud
[ -f "${HOMEBREW_PREFIX}/Caskroom/google-cloud-sdk/path.zsh.inc" ] && . "${HOMEBREW_PREFIX}/Caskroom/google-cloud-sdk/latest/google-cloud-sdk/path.zsh.inc"
[ -f "${HOMEBREW_PREFIX}/Caskroom/google-cloud-sdk/completion.zsh.inc" ] && . "${HOMEBREW_PREFIX}/Caskroom/google-cloud-sdk/latest/google-cloud-sdk/completion.zsh.inc"

# krew
[ -f "${HOMEBREW_PREFIX}/share/zsh/site-functions/kubesess.sh" ] && . ${HOMEBREW_PREFIX}/share/zsh/site-functions/kubesess.sh

# ssh-agent-multiplexer
if quietly type launchctl; then
  quietly launchctl load ~/Library/LaunchAgents/ssh-agent-multiplexer.plist >/dev/null || true
  launchctl start com.github.everpeace.ssh-agent-multiplexer
  [[ ! -v SSH_CONNECTION ]] && export SSH_AUTH_SOCK=$HOME/.ssh/ssh-agent-multiplexer/agent.sock
fi

# mise
if quietly type mise; then
  eval "$(mise activate zsh --shims)"
  eval "$(mise activate zsh)"
fi
