# Generate static completion files into ~/.zfuncs only if missing.
local ZFUNCS="${HOME}/.zfuncs"
mkdir -p "$ZFUNCS"

_gen_comp() {
  local out="$1"; shift
  # generate only if file is missing/empty and the command exists
  if [[ ! -s "$out" ]] && command -v "$1" >/dev/null 2>&1; then
    "$@" >| "$out" 2>/dev/null || true
  fi
}

# one-time generators
_gen_comp "$ZFUNCS/_docker"   docker completion zsh
_gen_comp "$ZFUNCS/_stern"    stern --completion=zsh
_gen_comp "$ZFUNCS/_helm"     helm completion zsh
_gen_comp "$ZFUNCS/_klog"     klog completion -c zsh
_gen_comp "$ZFUNCS/_kwokctl"  kwokctl completion zsh
_gen_comp "$ZFUNCS/_fke"      fke completion zsh
_gen_comp "$ZFUNCS/_task"     task --completion zsh
_gen_comp "$ZFUNCS/_uv"       uv generate-shell-completion zsh
_gen_comp "$ZFUNCS/_uvx"      uvx --generate-shell-completion zsh
_gen_comp "$ZFUNCS/_kubectl_check" kubectl-check completion zsh

# bun: symlink if available (fallback to copy)
if [[ -r "$HOME/.bun/_bun" && ! -e "$ZFUNCS/_bun" ]]; then
  ln -s "$HOME/.bun/_bun" "$ZFUNCS/_bun" 2>/dev/null || cp "$HOME/.bun/_bun" "$ZFUNCS/_bun"
fi
