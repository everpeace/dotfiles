#/bin/bash

function make_link()
{
  if [ $# -eq 1 ];then
    _filename=$1
    echo "ln -s $FROM/$_filename $TO/$_filename"
    ln -s $FROM/$_filename $TO/$_filename
  fi
}

# スクリプトのある場所
FROM=$(dirname $0)
FROM=`cd $FROM;pwd`

# リンクを張る場所
TO=$HOME

make_link .bash_profile
make_link .gitignore
make_link .vim
make_link .vimrc
make_link .zshrc

IFS=:
GIT=false
for d in $PATH
do test -x $d/git && GIT=true
done
if $GIT
then
  echo "git found!"
  # git config --global user.name "Shingo Omura"
  # git config --global user.email "everpeace@gmail.com"
  # git config --global core.excludesfile "$TO/.gitignore"
  make_link .gitconfig
else echo "no git"
fi

