export LANG=ja_JP.UTF-8
export LESSCHARSET=utf-8
export PS1="\h:\W \u$ "

alias ls='ls -aF'
alias sl='ls'

if [ -f $HOME/.bash_profile.mine ]; then
    source $HOME/.bash_profile.mine
fi

