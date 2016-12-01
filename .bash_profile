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

DOTFILE_DIR="$(readlink "${HOME}/.bash_profile" | sed -e 's/\/\.bash_profile//')"
PATH="${HOME}/.pyenv/shims:${HOME}/.cabal/bin:${HOME}/.svm/current/rt/bin:${DOTFILE_DIR}/svm:${HOME}/bin:${PATH}":/usr/local/sbin:/usr/local/bin
export PATH

# svm settings
export SCALA_HOME=${HOME}/.svm/current/rt

# gitsshm
log configuring gitsshm
alias gitsshm="source ${DOTFILE_DIR}/gitsshm/gitsshm"
gitsshm everpeace_cw

if [ -e /opt/chefdk/bin ]; then
  export PATH=/opt/chefdk/bin:${PATH}
fi

if [ -e /Developer/NVIDIA/CUDA-6.5 ]; then
  export PATH=/Developer/NVIDIA/CUDA-6.5/bin:${PATH}
  export DYLD_LIBRARY_PATH=/Developer/NVIDIA/CUDA-6.5/lib:${DYLD_LIBRARY_PATH}
fi

function git-root() {
  if git rev-parse --is-inside-work-tree > /dev/null 2>&1; then
    cd `pwd`/`git rev-parse --show-cdup`
  fi
}

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
    export GOPATH=/Users/omura/go
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
  GIT_PROMPT_START="\\n-(\\u@\\h)-(\\w)-\\n"
  GIT_PROMPT_END="\\n $ "
  PS1="${GIT_PROMPT_START} $ "
  GIT_PROMPT_ONLY_IN_REPO=1
  if is_installed bash-git-prompt; then
    log activating bash-git-prompt
    source "$(brew --prefix bash-git-prompt)/share/gitprompt.sh"
  else
    export PS1=${GIT_PROMPT_START}${GIT_PROMPT_END}
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
  git worktree add ${GIT_CDUP_DIR}git-worktrees/$1 -B $1
}

## source .bash_profile.mine ##
if [ -e "${HOME}/.bash_profile.mine" ]; then
  source "${HOME}/.bash_profile.mine"
fi

echo activating and configuring google-cloud-sdk
# The next line updates PATH for the Google Cloud SDK.
source '/Users/omura/google-cloud-sdk/path.bash.inc'

# The next line enables shell command completion for gcloud.
source '/Users/omura/google-cloud-sdk/completion.bash.inc'

# path to the DCOS CLI binary
if [[ "$PATH" != *"/Users/omura/dcos/bin"* ]];
  then export PATH=$PATH:/Users/omura/dcos/bin;
fi

# path to the DCOS CLI binary
if [[ "$PATH" != *"/Users/omura/Desktop/dcos/bin"* ]];
  then export PATH=$PATH:/Users/omura/Desktop/dcos/bin;
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
