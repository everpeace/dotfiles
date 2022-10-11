[user]
	# Need to renew this value when start using new machine
	signingkey = /Users/everpeace/Library/Containers/com.maxgoedjen.Secretive.SecretAgent/Data/PublicKeys/0e15f230cf807be6d9f2ccc883407109.pub
	email = everpeace@gmail.com
[commit]
	gpgsign = true
[gpg]
	format = ssh
[gpg "ssh"]
	allowedSignersFile = ~/.ssh/allowed_signers
[github]
	host = github.com
[include]
	path = ~/.vault/github.com.token
