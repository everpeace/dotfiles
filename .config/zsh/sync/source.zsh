# atuin
eval "$(atuin init zsh)"
# starship
eval "builtin $(starship init zsh)"

# zellij autostart
if [[ -z "$ZELLIJ" ]] && [[ "$TERM_PROGRAM" != "vscode" ]] && [[ -z "$SSH_TTY" ]] && [ -z "$TMUX" ]; then
    zellij $(zellij list-sessions --reverse --no-formatting \
        | fzf --ansi --exit-0 \
          --query '!EXITED' \
          --header 'SELECT ZELLIJ SESSION' \
          --bind 'enter:become(echo -e attach -c {1})' \
          --bind 'ctrl-r:reload(zellij list-sessions --reverse --no-formatting)' \
          --bind 'ctrl-c:abort' \
          --layout=reverse\
    )

    if [[ "$ZELLIJ_AUTO_EXIT" == "true" ]]; then
        exit
    fi
fi
