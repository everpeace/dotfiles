# starship
eval "builtin $(starship init zsh)"

# zellij
export ZELLIJ_AUTO_ATTACH=false
if [[ -z "$ZELLIJ" ]] && [[ "$TERM_PROGRAM" != "vscode" ]] && [[ -z "$SSH_TTY" ]] && [ -z "$TMUX" ]; then
    if [[ "$ZELLIJ_AUTO_ATTACH" == "true" ]]; then
        zellij attach -c
    else
        zellij
    fi

    if [[ "$ZELLIJ_AUTO_EXIT" == "true" ]]; then
        exit
    fi
fi
