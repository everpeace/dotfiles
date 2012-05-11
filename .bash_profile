export LANG=ja_JP.UTF-8
export LESSCHARSET=utf-8
export PS1="\h:\W \u$ "

alias ls='ls -aF'
alias sl='ls'

# svm settings
DOTFILE_DIR=`readlink "${HOME}"/.bash_profile| sed -e 's/\/\.bash_profile//'`
PATH="${HOME}/.svm/current/rt/bin:${DOTFILE_DIR}/sbt-extras:${DOTFILE_DIR}/svm:${PATH}"
export PATH
export SCALA_HOME="${HOME}"/.svm/current/rt

alias gitsshm="source $DOTFILE_DIR/gitsshm"

## bash_completion ##
# brew's bash_completion
if [ -f /usr/local/bin/brew ]; then
  if [ -f `/usr/local/bin/brew --prefix`/etc/bash_completion ]; then
         . `/usr/local/bin/brew --prefix`/etc/bash_completion
  fi
fi
# .bash_completion in HOME
if [ -f "$HOME/.bash_completion" ]; then
  . "$HOME/.bash_completion"
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
if [ -f "$HOME/.bash_profile.mine" ]; then
    source "$HOME/.bash_profile.mine"
fi


