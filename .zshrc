# locate brew first
if type brew >/dev/null 2>&1; then
    eval $(brew shellenv)
elif [ -f $HOME/.local/init_brew.sh ]; then
    source $HOME/.local/init_brew.sh
elif [ -f /opt/homebrew/bin/brew ]; then
    eval $(/opt/homebrew/bin/brew shellenv)
else
    echo 2>&1 "WARNING: brew not found."
fi

# load sheldon if installed
type sheldon >/dev/null 2>&1 \
    && eval "$(sheldon source)"
