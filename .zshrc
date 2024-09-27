### zprof start when ~/.zshrc.prof exists
if [ -f "$HOME/.zshrc.prof" ]; then
    zmodload zsh/zprof && zprof
fi

typeset -U path cdpath fpath manpath

if [ $(uname) = "Linux" ]; then
    export XDG_CACHE_HOME="${HOME}/.local_linux/cache"
    export XDG_STATE_HOME="${HOME}/.local_linux/state"
    export XDG_DATA_HOME="${HOME}/.local_linux/share"
    export KREW_ROOT="${XDG_DATA_HOME}/krew"
fi

# Brew
if type brew >/dev/null 2>&1; then
    eval $(brew shellenv)
elif [ -f $HOME/.local/init_brew.sh ]; then
    source $HOME/.local/init_brew.sh
elif [ -f /opt/homebrew/bin/brew ]; then
    eval $(/opt/homebrew/bin/brew shellenv)
else
    echo 2>&1 "WARNING: brew not found."
fi

#
# blazing fast statup by zcompiling everyghing including sheldon source
# ref: https://zenn.dev/fuzmare/articles/zsh-plugin-manager-cache
#
function source {
  ensure_zcompiled $1
  builtin source $1
}
function ensure_zcompiled {
  local compiled="$1.zwc"
  if [[ ! -r "$compiled" || "$1" -nt "$compiled" ]]; then
    echo "Compiling $1"
    zcompile $1
  fi
}
ensure_zcompiled ~/.zshrc

cache_dir=${XDG_CACHE_HOME:-$HOME/.cache}
sheldon_cache="$cache_dir/sheldon.zsh"
sheldon_toml="$HOME/.config/sheldon/plugins.toml"
if [[ ! -r "$sheldon_cache" || "$sheldon_toml" -nt "$sheldon_cache" ]]; then
  mkdir -p $cache_dir
  sheldon source > $sheldon_cache
fi
source "$sheldon_cache"
unset cache_dir sheldon_cache sheldon_toml
zsh-defer unfunction source

### show zprof result when ~/.zshrc.prof exists
if [ -f "$HOME/.zshrc.prof" ]; then
  zprof | less
fi
