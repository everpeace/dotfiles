# configure home brew packages
export HOMEBREW_CASK_OPTS="--appdir=/Applications"

if type brew >/dev/null 2>&1; then
  log activating zsh/site-functions,zsh/zsh-completions
  FPATH=${HOMEBREW_PREFIX}/share/zsh/site-functions:$FPATH
  FPATH=${HOMEBREW_PREFIX}/share/zsh-completions:$FPATH

  log activating autojump
  [[ -s ${HOMEBREW_PREFIX}/etc/autojump.sh ]] && . ${HOMEBREW_PREFIX}/etc/autojump.sh

  log activating direnv
  eval "$(direnv hook zsh)"

  log exporting GOROOT, GOPATH and PATH.
  export GOROOT=${HOMEBREW_PREFIX}/opt/go/libexec
  export GOPATH=${HOME}/go
  export PATH=${GOPATH}/bin:${GOROOT}/bin:${PATH}

  log setting up GPG_TTY
  export GPG_TTY=$(tty)

  log activating stern completion
  source <(stern --completion=zsh)

  log activating src-hilight
  export LESSOPEN="| ${HOMEBREW_PREFIX}/bin/src-hilite-lesspipe.sh  %s"

  log activating zsh-autosuggestions
  source ${HOMEBREW_PREFIX}/share/zsh-autosuggestions/zsh-autosuggestions.zsh

  log activating zsh-substring-search
  source ${HOMEBREW_PREFIX}/share/zsh-history-substring-search/zsh-history-substring-search.zsh

  log activating zsh-syntax-hilighting
  export ZSH_HIGHLIGHT_HIGHLIGHTERS_DIR=${HOMEBREW_PREFIX}/share/zsh-syntax-highlighting/highlighters
  source ${HOMEBREW_PREFIX}/share/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh
fi
