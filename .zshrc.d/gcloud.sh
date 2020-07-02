if [ -e "/usr/local/Caskroom/google-cloud-sdk" ]; then
  log activating and configuring google-cloud-sdk
  # The next line updates PATH for the Google Cloud SDK.
  source '/usr/local/Caskroom/google-cloud-sdk/latest/google-cloud-sdk/path.zsh.inc'

  # The next line enables shell command completion for gcloud.
  source '/usr/local/Caskroom/google-cloud-sdk/latest/google-cloud-sdk/completion.zsh.inc'
fi
