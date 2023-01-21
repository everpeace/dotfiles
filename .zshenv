### zprof start when ~/.zshrc.prof exists
if [ -f "$HOME/.zshrc.prof" ]; then
    zmodload zsh/zprof && zprof
fi

# locate brew
if type brew >/dev/null 2>&1; then
    eval $(brew shellenv)
elif [ -f $HOME/.local/init_brew.sh ]; then
    source $HOME/.local/init_brew.sh
elif [ -f /opt/homebrew/bin/brew ]; then
    eval $(/opt/homebrew/bin/brew shellenv)
else
    echo 2>&1 "WARNING: brew not found."
fi
