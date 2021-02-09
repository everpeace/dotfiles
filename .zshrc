# init homebrew
if [ -f $HOME/.local/init_brew.sh ]; then 
    source $HOME/.local/init_brew.sh
else
    eval $(/usr/local/bin/brew shellenv)
fi

# Language Setting
export LANG=ja_JP.UTF-8
export LC_ALL=${LANG}

# Pager
export LESSCHARSET=utf-8
export LESS="-R"
export EDITOR='vim'
export MANPAGER='less -R'
# colorize man
man() {
    env \
        LESS_TERMCAP_mb=$(printf "\e[1;33m") \
        LESS_TERMCAP_md=$(printf "\e[1;36m") \
        LESS_TERMCAP_me=$(printf "\e[0m") \
        LESS_TERMCAP_se=$(printf "\e[0m") \
        LESS_TERMCAP_so=$(printf "\e[1;44;33m") \
        LESS_TERMCAP_ue=$(printf "\e[0m") \
        LESS_TERMCAP_us=$(printf "\e[1;32m") \
        man "$@"
}

# PATHの重複をなくす
typeset -U path cdpath fpath manpath

alias log='>&2 echo \[.zshrc\] '
bindkey -e
autoload colors

source_all() {
    local dir=$1
    for f in $(ls -1 $dir/*); do
        . $f
    done
}

source_all ~/.zshrc.d
if [ -e ~/.local/.zshrc ]; then
    . ~/.local/.zshrc
fi

# # powerline
# . /usr/local/lib/python2.7/site-packages/powerline/bindings/zsh/powerline.zsh

[ -e ${KREW_ROOT:-$HOME/.krew}/bin ] && log add krew to PATH && export PATH="${KREW_ROOT:-$HOME/.krew}/bin:$PATH"
[ -e /usr/local/kubebuilder/bin ] && log add kubebuilder to PATH && export PATH=$PATH:/usr/local/kubebuilder/bin
export PATH="${HOME}/.embulk/bin::${HOME}/bin:${PATH}"

# if (which zprof > /dev/null 2>&1) ;then
#   zprof
# fi
