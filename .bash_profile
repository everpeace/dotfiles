#! /bin/bash
export LANG=ja_JP.UTF-8
export LC_ALL=${LANG}
export LESSCHARSET=utf-8
export LESS="-R"
export PS1="\h:\W \u$ "

alias ls='ls -aF'
alias sl='ls'
alias scalaz7='screpl org.scalaz%scalaz-example_2.11.0%7.1.0.RC1'
alias log='>&2 echo [bash_profile] '
alias kubeflc='kubectl --namespace flccm'

DOTFILE_DIR="$(readlink "${HOME}/.bash_profile" | sed -e 's/\/\.bash_profile//')"
PATH="${HOME}/.pyenv/shims:${HOME}/.cabal/bin:${HOME}/.svm/current/rt/bin:${DOTFILE_DIR}/svm:${HOME}/bin:${HOME}/.cargo/bin:${PATH}":/usr/local/sbin:/usr/local/bin
export PATH=$PATH:${HOME}/.minimesos/bin
export PATH

# svm settings
export SCALA_HOME=${HOME}/.svm/current/rt

# gitsshm
log configuring gitsshm
alias gitsshm="source ${DOTFILE_DIR}/gitsshm/gitsshm"
gitsshm everpeace_github

if [ -e /opt/chefdk/bin ]; then
  export PATH=/opt/chefdk/bin:${PATH}
fi

if [ -e /Developer/NVIDIA/CUDA-6.5 ]; then
  export PATH=/Developer/NVIDIA/CUDA-6.5/bin:${PATH}
  export DYLD_LIBRARY_PATH=/Developer/NVIDIA/CUDA-6.5/lib:${DYLD_LIBRARY_PATH}
fi

function git-root() {
  if git rev-parse --is-inside-work-tree > /dev/null 2>&1; then
    echo `pwd`/`git rev-parse --show-cdup`
  fi
}

function mkdircd() { mkdir "$@" && eval cd "\"\$$#\""; }

export VIRTUAL_ENV_DISABLE_PROMPT=1
function virtualenv_info(){
  if [[ -n "$VIRTUAL_ENV" ]]; then
    echo -n "[venv:`basename "$VIRTUAL_ENV"`]-"
  fi
}
VENV="\$(virtualenv_info)"

# configuration for packages installed by Homebrew
export HOMEBREW_CASK_OPTS="--appdir=/Applications"
if [ -f /usr/local/bin/brew ]; then
  brew_list_cache=$(brew list -1)
  brew_prefix=$(brew --prefix)

  is_installed(){
    if [ "$(echo "$brew_list_cache" |grep -c ^$1$)" = "1" ]; then
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

  if is_installed bash-completion; then
    log activating bash_completion
    source "$brew_prefix/etc/bash_completion"
  fi

  if is_installed source-highlight; then
    log exporting LESSOPEN with source-highlight
    export LESSOPEN="| $brew_prefix/bin/src-hilite-lesspipe.sh %s"
  fi

  if is_installed todo-txt; then
    log activating todo-txt
    alias t='LC_ALL=C todo.sh'
    complete -F _todo -o default t
    alias te='vi ~/Dropbox/todo/todo.txt'
    export TODO_ACTIONS_DIR=${HOME}"/.todo.actions.d"
  fi

  if is_installed autojump; then
    log activating autojump
    [[ -s $brew_prefix/etc/autojump.sh ]] && . "$brew_prefix/etc/autojump.sh"
  fi

  if is_installed awscli; then
    log activating aws_completer
    complete -C aws_completer aws
  fi

  # git completion and prompt settings
  GIT_PROMPT_THEME=Default
  GIT_PROMPT_START="\\n-(\\u@\\h)-(\\w)-${VENV}\\n"
  GIT_PROMPT_END=" $ "
  PS1="${GIT_PROMPT_START} $ "
  GIT_PROMPT_ONLY_IN_REPO=1
  if is_installed bash-git-prompt; then
    log activating bash-git-prompt
    source "$(brew --prefix bash-git-prompt)/share/gitprompt.sh"
  fi

  if [ -f $brew_prefix/bin/nvm.sh ]; then
    log activating nvm
    source $(brew --prefix nvm)/nvm.sh
    NVM_DIR=~/.nvm
  fi

  if is_installed vim; then
    log exporting EDITOR, vi, vim
    export EDITOR="$brew_prefix/bin/vim"
    alias vi='env LANG=ja_jp.utf-8 $brew_prefix/bin/vim "$@"'
    alias vim='env LANG=ja_jp.utf-8 $brew_prefix/bin/vim "$@"'
  fi

  if is_installed rbenv; then
    log activating rbenv
    eval "$(rbenv init -)"
    source "/usr/local/Cellar/rbenv/$(brew list --versions rbenv|cut -d ' ' -f2 )/completions/rbenv.bash"
  fi

  if is_installed pyenv; then
    log activating pyenv
    eval "$(pyenv init -)";
  fi
  if is_installed pyenv-virtualenv; then
    log activating pyenv-virtualenv
    eval "$(pyenv virtualenv-init -)";
  fi

  # Deprecated: use docker-machine
  # if is_installed boot2docker; then
  #   boot2dockerstatus=$(boot2docker status 2>/dev/null || echo "x")
  #   if [ "running" == "${boot2dockerstatus}" ]; then
  #     export DOCKER_HOST=tcp://$(boot2docker --verbose=false ip):2375
  #   fi
  # fi

  if is_installed lnav; then
    log exporting LNAV_EXP
    export LNAV_EXP="mouse";
  fi

  if is_installed direnv; then
    log activating direnv
    eval "$(direnv hook bash)"
  fi

  if is_installed dvm; then
    log activating dvm
    dvm_prefix=$(brew --prefix dvm)
    [[ -s "$dvm_prefix/dvm.sh" ]] && source "$dvm_prefix/dvm.sh"
  fi

  if is_installed octave; then
    log alias octave with octave --no-gui-libs
    alias octave='octave --no-gui-libs'
  fi

  if is_installed exa; then
    log alas ls with exa -aF
    alias ls='exa -aF'
  fi

  if is_installed kubernetes-tools; then
    log activating kubernetes-tools completion
    source /usr/local/Cellar/kubernetes-tools/1.0.0/completion/__completion
  fi

  if is_installed stern; then
    log activating stern completion
    source <(stern --completion=bash)
  fi

  if is_installed gpg; then
    log setting up GPG_TTY
    export GPG_TTY=$(tty)
  fi

  if is_installed opam; then
    log setting up opam
    if [ -e $HOME/.opam/opam-init/init.sh ]; then
      # OPAM configuration
      . $HOME/.opam/opam-init/init.sh > /dev/null 2> /dev/null || true
      eval `opam config env`
    else
      log "WARN run 'opam init' and answer 'no' for automatic configuration"
    fi
  fi

  if is_installed hh; then
    # hh settings
    log activating hh
    # add this configuration to ~/.bashrc
    export HH_CONFIG=hicolor           # get more colors
    shopt -s histappend                # append new history items to .bash_history
    export HISTCONTROL=ignorespace     # leading space hides commands from history
    export HISTFILESIZE=100000         # increase history file size (default is 500)
    export HISTSIZE=${HISTFILESIZE}    # increase history size (default is 500)
    export PROMPT_COMMAND="history -a; history -n; ${PROMPT_COMMAND}"   # mem/file sync
    # if this is interactive shell, then bind hh to Ctrl-r (for Vi mode check doc)
    if [[ $- =~ .*i.* ]]; then bind '"\C-r": "\C-a hh -- \C-j"'; fi
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

## source .bash_profile.mine ##
if [ -e "${HOME}/.bash_profile.mine" ]; then
  source "${HOME}/.bash_profile.mine"
fi

if [ -e "${HOME}/google-cloud-sdk" ]; then
  log activating and configuring google-cloud-sdk
  # The next line updates PATH for the Google Cloud SDK.
  source '${HOME}/google-cloud-sdk/path.bash.inc'

  # The next line enables shell command completion for gcloud.
  source '${HOME}/google-cloud-sdk/completion.bash.inc'
fi

# path to the DCOS CLI binary
if [[ "$PATH" != *"${HOME}/dcos/bin"* ]];
  then export PATH=$PATH:${HOME}/dcos/bin;
fi

# path to the DCOS CLI binary
if [[ "$PATH" != *"${HOME}/Desktop/dcos/bin"* ]];
  then export PATH=$PATH:${HOME}/Desktop/dcos/bin;
fi

# Microsoft R Open
if [ -e /Applications/Microsoft\ R\ Open.app/ ]; then
  log exporting RSTUDIO_WITH_R with Microsoft R Open
  export RSTUDIO_WHICH_R=/Applications/Microsoft\ R\ Open.app/Contents/MacOS/Microsoft\ R\ Open
fi
alias RStudio='open -a RStudio'

# kubectl bash completion
if [ -e /usr/local/bin/kubectl ]; then
  log activating kubectl bash completion
  source <(kubectl completion bash)
fi

if [ -e /usr/local/bin/helm ]; then
  log activating helm bash completion
  source <(helm completion bash)
fi

if is_installed mono; then
  log exporting MONO_GAC_PREFIX
  export MONO_GAC_PREFIX="/usr/local"
  log exporting MONO_IOMAP
  export MONO_IOMAP=case
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
