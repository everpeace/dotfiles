[user]
	signingkey = C248C3C150CB268797C47B53C4B9C73F26C783AF
	email = everpeace@gmail.com
[commit]
	gpgsign = true
[gpg]
	program = gpg
[github]
	host = github.com
[include]
	path = ~/.vault/github.com.token
