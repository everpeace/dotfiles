### zprof start when ~/.zshrc.prof exists
if [ -f "$HOME/.zshrc.prof" ]; then
    zmodload zsh/zprof && zprof
fi
