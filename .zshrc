if [ -f "$HOME/.zshrc.prof" ]; then
    zmodload zsh/zprof && zprof
fi
if [ -f "$HOME/.zshrc.debug" ]; then
    alias log='>&2 echo \[$(basename ${(%):-%N})\] '
else;
    alias log=': '
fi

[ -f "${HOME}/.zshrc.zwc" -o "${HOME}/.zshrc" -nt "${HOME}/.zshrc.zwc" ] || zcompile "${_ZSH_RC_PATH}"

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
bindkey -e
autoload colors
autoload -Uz compinit
compinit -u

source_single() {
    local f="$1"
    [ -f "$f.zwc" -o "$f" -nt "$f.zwc" ] || zcompile $f
    . $f
}

source_all() {
    local dir=$1
    for f in $(ls -1 $dir/* | grep -v ".zwc$"); do
        source_single $f
    done
}

source_all ~/.zshrc.d
if [ -e ~/.local/.zshrc ]; then
    source_single ~/.local/.zshrc
fi

# # powerline
# . /usr/local/lib/python2.7/site-packages/powerline/bindings/zsh/powerline.zsh

# 補完関数の表示を強化する
zstyle ':completion:*' verbose yes
zstyle ':completion:*' completer _expand _complete _match _prefix _approximate _list _history
zstyle ':completion:*:messages' format '%F{YELLOW}%d'$DEFAULT
zstyle ':completion:*:warnings' format '%F{RED}No matches for:''%F{YELLOW} %d'$DEFAULT
zstyle ':completion:*:descriptions' format '%F{YELLOW}completing %B%d%b'$DEFAULT
zstyle ':completion:*:options' description 'yes'
zstyle ':completion:*:descriptions' format '%F{yellow}Completing %B%d%b%f'$DEFAULT

# マッチ種別を別々に表示
zstyle ':completion:*' group-name ''

export PATH="${HOME}/bin:${PATH}"
[ -e ${KREW_ROOT:-$HOME/.krew}/bin ] && log add krew to PATH && export PATH="${KREW_ROOT:-$HOME/.krew}/bin:$PATH"
[ -e /usr/local/kubebuilder/bin ] && log add kubebuilder to PATH && export PATH=$PATH:/usr/local/kubebuilder/bin
[ -e ${HOME}/.embulk/bin ] && log add ~/.embalk/bin to PATH && PATH="${HOME}/.embulk/bin:${PATH}"

launchctl load ~/Library/LaunchAgents/ssh-agent-multiplexer.plist >/dev/null 2>&1 || true
launchctl start com.github.everpeace.ssh-agent-multiplexer
export SSH_AUTH_SOCK=/Users/everpeace/.ssh/ssh-agent-multiplexer/agent.sock

if [ -f "$HOME/.zshrc.prof" ]; then
    zprof
fi
