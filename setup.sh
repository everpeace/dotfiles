#! /bin/bash

LN="ln -hfs"  # mac
if ! ln -hfs /tmp/dummy . >/dev/null 2>&1; then
  LN="ln -fsT" # linux
fi

function make_link()
{
  if [ $# -eq 1 ];then
    _fromfilename=$1
    _tofilename=$1
  fi
  if [ $# -eq 2 ];then
    _fromfilename=$1
    _tofilename=$2
  fi
  if [ $# -eq 1 ] || [ $# -eq 2 ];then
    echo "$LN" "$FROM/$_fromfilename" "$TO/$_tofilename"
    $LN "$FROM/$_fromfilename" "$TO/$_tofilename"
  fi
}

# スクリプトのある場所
FROM=$(dirname "$0")
FROM=$(cd "$FROM"; pwd)

# リンクを張る場所
TO=$HOME

# make_link .bash_profile
make_link Brewfile .Brewfile
make_link Brewfile.lock.json .Brewfile.lock.json
make_link .tool-versions
make_link .asdfrc
make_link .vim
make_link .vimrc
make_link .zshrc
make_link .zshrc.d
make_link peco .config/peco
mkdir -p "$HOME/.config"
make_link powerline .config/powerline
make_link starship.toml .config/starship.toml
make_link bin
make_link .tmux.conf
make_link .mac-provisioning
make_link .tigrc
make_link .gitconfig
make_link .gitignore_global
make_link .gitconfig.d
make_link vault .vault
mkdir -p "$HOME/.config/memo"
make_link memo/config.toml .config/memo/config.toml
mkdir -p .gnupg
make_link .gnupg/gpg.conf
make_link .gnupg/gpg-agent.conf
ls ~/Library/LaunchAgents/ssh-agent-multiplexer.plist || make_link ssh-agent-multiplexer.plist Library/LaunchAgents/ssh-agent-multiplexer.plist
ls "${HOME}/bin/memo" || GOBIN="$HOME/bin/" go install github.com/mattn/memo@latest

mkdir -p ~/.ssh && chmod 700 ~/.ssh
make_link ssh/config .ssh/config
make_link ssh/conf.d .ssh/conf.d

ls ~/.tmux/plugins/tpm/tpm || git clone https://github.com/tmux-plugins/tpm ~/.tmux/plugins/tpm

# IFS=:
# GIT=false
# for d in $PATH
# do test -x "$d/git" && GIT=true
# done
# if $GIT
# then
#   echo "git found!"
#   # git config --global user.name "Shingo Omura"
#   # git config --global user.email "everpeace@gmail.com"
#   # git config --global core.excludesfile "$TO/.gitignore"
# else echo "no git"
# fi
