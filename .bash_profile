export LANG=ja_JP.UTF-8
export LESSCHARSET=utf-8
export PS1="\h:\W \u$ "

alias ls='ls -aF'
alias sl='ls'

DOTFILE_DIR=`readlink ${HOME}/.bash_profile| sed -e 's/\/\.bash_profile//'`
PATH="${HOME}/.svm/current/rt/bin:${DOTFILE_DIR}/svm:${PATH}"
export PATH

if [ -f $HOME/.bash_profile.mine ]; then
    source $HOME/.bash_profile.mine
fi

