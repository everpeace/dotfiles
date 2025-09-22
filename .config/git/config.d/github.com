[url "https://github.com/"]
	insteadOf = "ssh://git@github.com/"
	insteadOf = "git@github.com:"

[credential "https://github.com"]
	helper = 
	helper = !/opt/homebrew/bin/gh auth git-credential
[credential "https://gist.github.com"]
	helper = 
	helper = !/opt/homebrew/bin/gh auth git-credential

[user]
	# Bitwarden: "github.com everpeace"
	signingkey = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIDAqFtOcCXamAdiCA201r7M5vIJDzVu2DjPzKx6P1txt"
	email = everpeace@gmail.com
[commit]
	gpgsign = true
[gpg]
	format = ssh
[gpg "ssh"]
	allowedSignersFile = ~/.ssh/allowed_signers
[github]
	host = github.com
