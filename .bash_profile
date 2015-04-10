#! /bin/bash
export LANG=ja_JP.UTF-8
export LC_ALL=${LANG}
export LESSCHARSET=utf-8
export LESS="-R"
export PS1="\h:\W \u$ "

alias ls='ls -aF'
alias sl='ls'
alias scalaz7='screpl org.scalaz%scalaz-example_2.11.0%7.1.0.RC1'

DOTFILE_DIR="$(readlink "${HOME}/.bash_profile" | sed -e 's/\/\.bash_profile//')"
PATH="${HOME}/.pyenv/shims:${HOME}/.cabal/bin:${HOME}/.svm/current/rt/bin:${DOTFILE_DIR}/svm:${HOME}/bin:${PATH}":/usr/local/sbin:/usr/local/bin
export PATH

# svm settings
export SCALA_HOME=${HOME}/.svm/current/rt

# gitsshm
alias gitsshm="source ${DOTFILE_DIR}/gitsshm/gitsshm"

export GOROOT=$(brew --prefix)/opt/go/libexec
export GOPATH=/Users/shingo/go/1.3
export PATH=${PATH}:${GOROOT}/bin:${GOPATH}/bin

if [ -e /opt/chefdk/bin ]; then
  export PATH=/opt/chefdk/bin:${PATH}
fi

if [ -e /Developer/NVIDIA/CUDA-6.5 ]; then
  export PATH=/Developer/NVIDIA/CUDA-6.5/bin:${PATH}
  export DYLD_LIBRARY_PATH=/Developer/NVIDIA/CUDA-6.5/lib:${DYLD_LIBRARY_PATH}
fi

# configuration for packages installed by Homebrew
export HOMEBREW_CASK_OPTS="--appdir=/Applications"
if [ -f /usr/local/bin/brew ]; then

  is_installed(){
    if [ "$(brew list -1 |grep -c ^$1$)" = "1" ]; then
      return 0
    else
      return 1
    fi
  }

  if is_installed bash-completion; then
    source "$(brew --prefix)/etc/bash_completion"
  fi

  if is_installed source-highlight; then
    export LESSOPEN="| $(brew --prefix)/bin/src-hilite-lesspipe.sh %s"
  fi

  if is_installed todo-txt; then
    alias t='LC_ALL=C todo.sh'
    complete -F _todo -o default t
    alias te='vi ~/Dropbox/todo/todo.txt'
    export TODO_ACTIONS_DIR=${HOME}"/.todo.actions.d"
  fi

  if is_installed autojump; then
    [[ -s $(brew --prefix)/etc/autojump.sh ]] && . "$(brew --prefix)/etc/autojump.sh"
  fi

  if is_installed awscli; then
    complete -C aws_completer aws
  fi

  # git completion and prompt settings
  GIT_PROMPT_THEME=Default
  GIT_PROMPT_START="\\n-(\\u@\\h)-(\\w)-\\n"
  GIT_PROMPT_END=" $ "
  if is_installed bash-git-prompt; then
    source "$(brew --prefix bash-git-prompt)/share/gitprompt.sh"
  else
    export PS1=${GIT_PROMPT_START}${GIT_PROMPT_END}
  fi

  if [ -f $(brew --prefix)/bin/nvm.sh ]; then
    source $(brew --prefix nvm)/nvm.sh
    NVM_DIR=~/.nvm
  fi

  if is_installed vim; then
    export EDITOR="$(brew --prefix)/bin/vim"
    alias vi='env LANG=ja_jp.utf-8 $(brew --prefix)/bin/vim "$@"'
    alias vim='env LANG=ja_jp.utf-8 $(brew --prefix)/bin/vim "$@"'
  fi

  if is_installed rbenv; then
    eval "$(rbenv init -)"
    source "/usr/local/Cellar/rbenv/$(brew list --versions rbenv|cut -d ' ' -f2 )/completions/rbenv.bash"
  fi

  if is_installed pyenv; then eval "$(pyenv init -)"; fi
  if is_installed pyenv-virtualenv; then eval "$(pyenv virtualenv-init -)"; fi

  if is_installed boot2docker; then
    boot2dockerstatus=$(boot2docker status 2>/dev/null || echo "x")
    if [ "running" == "${boot2dockerstatus}" ]; then
      export DOCKER_HOST=tcp://$(boot2docker --verbose=false ip):2375
    fi
  fi

  if is_installed lnav; then export LNAV_EXP="mouse"; fi

fi

## source .bash_profile.mine ##
if [ -e "${HOME}/.bash_profile.mine" ]; then
  source "${HOME}/.bash_profile.mine"
fi
