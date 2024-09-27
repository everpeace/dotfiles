# locale
export LANG="ja_JP.UTF-8"
export LC_ALL="${LANG}"

# pager
export LESSCHARSET=utf-8
export LESS="-R"
export EDITOR='vim'
export MANPAGER='less -R'

# # rye
# source "$HOME/.rye/env"

# golang
export GOPATH="$HOME/go"
export PATH="$GOPATH/bin:$PATH"

# krew
if [ -e ${KREW_ROOT:-$HOME/.krew}/bin ]; then
    export PATH="${KREW_ROOT:-$HOME/.krew}/bin:$PATH"
fi

# local bins
export PATH="$HOME/bin:$HOME/.local/bin:$PATH"

# gpg
export GPG_TTY=$(tty)
