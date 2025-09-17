#
# Configure zsh-autocomplete
# ref: https://github.com/marlonrichert/zsh-autocomplete?tab=readme-ov-file#configuration
#

# <-,-> can move on the command line
bindkey -M menuselect  '^[[D' .backward-char  '^[OD' .backward-char
bindkey -M menuselect  '^[[C'  .forward-char  '^[OC'  .forward-char

# pass arguments to compinit
zstyle '*:compinit' arguments -D -i -u -C -w

# umbiguous search
zstyle ':autocomplete:*complete*:*' insert-unambiguous yes
zstyle ':autocomplete:*history*:*' insert-unambiguous yes
zstyle ':autocomplete:menu-search:*' insert-unambiguous yes

# Start each command line in history search mode
# zstyle ':autocomplete:*' default-context history-incremental-search-backward

# Change the max number of lines shown
## Override for history search only
zstyle ':autocomplete:history-incremental-search-backward:*' list-lines 8
## Override for history menu only
zstyle ':autocomplete:history-search-backward:*' list-lines 2000
