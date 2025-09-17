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

# 流量制御(Ctrl-S/Q) 無効化：誤作動で入力が止まるのを防ぐ
stty -ixon

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

# --- defer ログの保存先（XDG系が無ければ ~/.local/state を使う）
: ${XDG_STATE_HOME:=$HOME/.local/state}
DEFER_LOG_DIR="$XDG_STATE_HOME/zsh"
mkdir -p "$DEFER_LOG_DIR"
DEFER_LOG="$DEFER_LOG_DIR/defer.log"

# --- zcompile してから source（正しい条件）
_sheldon_src() {
  local f="$1"
  if [[ ! -r "$f.zwc" || "$f" -nt "$f.zwc" ]]; then
    zcompile "$f"
  fi
  builtin source "$f"
}

# --- ログ付き：/dev/tty にも出す（printfの日時書式は使わず print -P で時刻生成）
_sheldon_src_logged() {
  local f="$1" start=$EPOCHREALTIME
  _sheldon_src "$f"

  # 浮動小数で経過時間を計算（zshはそのままfloat演算OK）
  typeset -F dur
  (( dur = EPOCHREALTIME - start ))

  # 時刻は zsh の prompt 拡張で生成（printfの %(... )T は使わない）
  local ts; ts=$(print -P '%D{%H:%M:%S}')

  # 3桁小数に整形
  local line="[$ts] defer $f took $(printf '%.3f' $dur)s"
  print -r -- "$line" >> "$DEFER_LOG"
  print -r -- "$line" > /dev/tty
}

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
unfunction source

### show zprof result when ~/.zshrc.prof exists
if [ -f "$HOME/.zshrc.prof" ]; then
  zprof | less
fi
