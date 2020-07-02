if [ -e /usr/local/bin/helm ]; then
  log activating helm zsh completion
  source <(helm completion zsh)
fi
