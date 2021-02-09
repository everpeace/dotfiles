#
# zplug
#
export ZPLUG_HOME=$(brew --prefix)/opt/zplug
source $ZPLUG_HOME/init.zsh

# zplug itself
zplug 'zplug/zplug', hook-build:'zplug --self-manage'
#
# Prezto
#
# zplug "sorin-ionescu/prezto" #, \
  #  use:"init.zsh", \
  #  hook-build:"ln -s $ZPLUG_HOME/repos/sorin-ionescu/prezto ~/.zprezto"

# zplug "modules/environment", from:prezto, lazy:true
# zplug "modules/terminal", from:prezto, lazy:true
# zplug "modules/editor", from:prezto
# zplug "modules/history", from:prezto
# zplug "modules/directory", from:prezto
# # zplug "modules/spectrum", from:prezto
# zplug "modules/utility", from:prezto
# zplug "modules/completion", from:prezto
# # # zplug "modules/contrib-prompt", from:prezto
# # # zplug "modules/prompt", from:prezto
# zplug "modules/homebrew", from:prezto, lazy:true
# # zplug "modules/ruby", from:prezto
# zplug "modules/python", from:prezto
# zplug "modules/autosuggestions", from:prezto, lazy:true
# # zplug "modules/fasd", from:prezto
# zplug "modules/gnu-utility", from:prezto
# zplug "modules/git", from:prezto
# zplug "modules/history-substring-seach", from:prezto
# zplug "modules/tmux", from:prezto
# zplug "modules/syntax-highlighting", from:prezto

# # pretzo configuration
# zstyle ':prezto:module:utility' safe-ops 'no'
# zstyle ':prezto:module:python:virtualenv' auto-switch 'yes'
# zstyle ':prezto:module:tmux:auto-start' local 'no'
# zstyle ':prezto:module:syntax-highlighting' color 'yes'
# zstyle ':prezto:module:syntax-highlighting' highlighters \
#   'main' \
#   'brackets' \
#   'pattern' \
#   'line' \
#   'cursor' \
#   'root'
# # END: Prezto

# # oh-my-zsh
zplug "plugins/autojump", from:oh-my-zsh
zplug "plugins/kubectl", from:oh-my-zsh
zplug "plugins/gnu-utils", from:oh-my-zsh
zplug "plugins/git", from:oh-my-zsh
# zplug "plugins/github", from:oh-my-zsh
zplug "plugins/gitignore", from:oh-my-zsh
# # END: oh-my-zsh

#
# zsh plugins
#
zplug "zsh-users/zsh-autosuggestions"
zplug "zsh-users/zsh-completions"
zstyle ':completion:*' verbose yes
zstyle ':completion:*' list-colors ${(s.:.)LS_COLORS}
zstyle ':completion:*:default' menu select=2
zplug "zsh-users/zsh-history-substring-search"
zplug "zsh-users/zsh-syntax-highlighting", defer:2
ZSH_HIGHLIGHT_HIGHLIGHTERS=(main brackets pattern cursor)
zplug "mollifier/cd-gitroot"
zplug "davidparsson/zsh-pyenv-lazy"

# Can manage local plugins
mkdir -p ~/.zsh
zplug "~/.zsh", from:local
# END: zsh plugins


if ! zplug check --verbose; then
  printf 'Install? [y/N]: '
  if read -q; then
    echo; zplug install
  fi
fi
# log "zplug load started in $((SECONDS - sec)) seconds."
zplug load
# log "zplug loaded finished in $((SECONDS - sec)) seconds."
