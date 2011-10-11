export LANG=ja_JP.UTF-8
export LESSCHARSET=utf-8

export EDITOR=/Applications/MacVim.app/Contents/MacOS/Vim
alias vi='env LANG=ja_JP.UTF-8 /Applications/MacVim.app/Contents/MacOS/Vim "$@"'
alias vim='env LANG=ja_JP.UTF-8 /Applications/MacVim.app/Contents/MacOS/Vim "$@"'

if [ -f $HOME/.bash_profile.mine]; then
    source $HOME/.bash_profile.mine
fi

