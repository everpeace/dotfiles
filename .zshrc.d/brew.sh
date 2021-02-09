# configure home brew packages
export HOMEBREW_CASK_OPTS="--appdir=/Applications"
if which brew >/dev/null 2>&1; then
  # brew_list_cache=$(brew list -1)
  brew_prefix=$(brew --prefix)

  # is_installed(){
  #   if [ "$(echo "$brew_list_cache" |grep -c "^$1$")" = "1" ]; then
  #     return 0
  #   else
  #     return 1
  #   fi
  # }

  # if is_installed go; then
    log exporting GOROOT, GOPATH and PATH.
    export GOROOT=$brew_prefix/opt/go/libexec
    export GOPATH=${HOME}/go
    export PATH=${PATH}:${GOROOT}/bin:${GOPATH}/bin
  # fi

  # if is_installed direnv; then
    log activating direnv
    eval "$(direnv hook zsh)"
  # fi

  # if is_installed stern; then
    log activating stern completion
    source <(stern --completion=zsh)
  # fi

  # if is_installed gpg; then
    log setting up GPG_TTY
    export GPG_TTY=$(tty)
  # fi
fi