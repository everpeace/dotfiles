.PHONY: install
install:
	./install.sh

.PHONY: brew-bundle
brew-bundle:
	brew bundle

.PHONY: brew-bundle-dump
brew-bundle-dump:
	brew bundle dump -f
