#!/usr/bin/env bash

if [[ "$TERM_PROGRAM" == "vscode" ]]; then
    code --wait "$@"
else
    ${EDITOR:-vim} "$@"
fi
