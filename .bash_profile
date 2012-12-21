export LANG=ja_JP.UTF-8
export LESSCHARSET=utf-8
export LESS="-R"
export PS1="\h:\W \u$ "

alias ls='ls -aF'
alias sl='ls'

# svm settings
DOTFILE_DIR=`readlink ${HOME}/.bash_profile| sed -e 's/\/\.bash_profile//'`
PATH="${HOME}/.svm/current/rt/bin:${DOTFILE_DIR}/sbt-extras:${DOTFILE_DIR}/svm:${HOME}/bin:${PATH}"
export PATH
export SCALA_HOME=${HOME}/.svm/current/rt

alias gitsshm="source $DOTFILE_DIR/gitsshm/gitsshm"
alias t='todo.sh'
complete -F _todo -o default t
alias te='vi ~/Dropbox/todo/todo.txt'

## bash_completion and source-highlight##
# brew's bash_completion and source-hightlight
if [ -f /usr/local/bin/brew ]; then
  if [ -f `/usr/local/bin/brew --prefix`/etc/bash_completion ]; then
         . `/usr/local/bin/brew --prefix`/etc/bash_completion
  fi
  if [ -f `/usr/local/bin/brew --prefix`/bin/src-hilite-lesspipe.sh ]; then
         export LESSOPEN="| `/usr/local/bin/brew --prefix`/bin/src-hilite-lesspipe.sh %s"
  fi
fi
# .bash_completion in HOME
if [ -f $HOME/.bash_completion ]; then
  . $HOME/.bash_completion
fi
# git completion and prompt settings
if [ -f /usr/local/git/contrib/completion/git-completion.bash ]; then
  source /usr/local/git/contrib/completion/git-completion.bash
  git_branch() {
   __git_ps1 '(git:%s)'
  }
  export PS1="\\e]2;\$(git_branch)\\a\\n-(\\u@\\h)-(\\w)-\\n\$(git_branch) $ "
else
  export PS1="\\n[\\w]\\n\\u@\h $ "
fi
# Vim
if [ -f /Applications/MacVim.app ]; then
  export EDITOR=/Applications/MacVim.app/Contents/MacOS/Vim
   alias vi='env LANG=ja_jp.utf-8 /Applications/Mail.app/Contents/MacOS/Vim "$@"'
   alias vim='env LANG=ja_jp.utf-8 /Applications/Mail.app/Contents/MacOS/Vim "$@"'
fi
## source .bash_profile.mine ##
if [ -f $HOME/.bash_profile.mine ]; then
    source $HOME/.bash_profile.mine
fi

alias scalaz7='screpl org.scalaz%scalaz-example_2.9.2%7.0.0-M3'

if [ -f /usr/local/Cellar/rbenv/0.3.0/completions/rbenv.bash ]; then
  eval "$(rbenv init -)"
  source /usr/local/Cellar/rbenv/0.3.0/completions/rbenv.bash
fi

export TODO_ACTIONS_DIR=$HOME"/.todo.actions.d"


