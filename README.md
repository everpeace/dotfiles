# dotfiles

my dot files.


## install

0. install prerequisistes: [https://brew.sh](brew.sh), [gh](https://github.com/cli/cli)

   ```console
   /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"

   brew install gh
   ```

1. clone this repo

   ```
   gh auth login
   gh repo clone everpeace/dotfiles ~/src/github.com/everpeace/dotfiles
   ```

2. install brew packages

   ```console
    ~/src/github.com/everpeace/dotfiles
   make brew-bundle
   ```

3. install shell environment

   ```console
   make install
   ```

