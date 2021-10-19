#! /bin/bash

LN="ln -hfs"  # mac
if ! ln -hfs /tmp/dummy >/dev/null 2>&1; then
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
  if [ $# -eq 1 -o $# -eq 2 ];then
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
make_link .Brewfile
make_link .Brewfile.lock.json
make_link .vim
make_link .vimrc
make_link .zshrc
make_link .zshrc.d
make_link peco .config/peco
mkdir -p $HOME/.config
make_link powerline .config/powerline
make_link starship.toml .config/starship.toml
make_link .Rprofile
make_link bin
make_link .tmux.conf
make_link .mac-provisioning
make_link .tigrc
make_link .octaverc
make_link .ocamlinit
make_link .gitconfig
make_link .gitignore_global
make_link .gitconfig.d
make_link vault .vault

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
