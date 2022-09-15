if [ -e "/opt/homebrew/Caskroom/google-cloud-sdk" ]; then
  log activating and configuring google-cloud-sdk
  # The next line updates PATH for the Google Cloud SDK.
  source '/opt/homebrew/Caskroom/google-cloud-sdk/latest/google-cloud-sdk/path.zsh.inc'

  # The next line enables shell command completion for gcloud.
  source '/opt/homebrew/Caskroom/google-cloud-sdk/latest/google-cloud-sdk/completion.zsh.inc'
fi
