#/bin/bash

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
    echo "ln -hfs $FROM/$_fromfilename $TO/$_tofilename"
    ln -hfs $FROM/$_fromfilename $TO/$_tofilename
  fi
}

# スクリプトのある場所
FROM=$(dirname $0)
FROM=`cd $FROM;pwd`

# リンクを張る場所
TO=$HOME

make_link .bash_profile
make_link .gitignor
make_link .vim
make_link .vimrc
make_link .zshrc
make_link .screenrc
make_link .Rprofile
make_link msmtp/.msmtprc .msmtprc
make_link msmtp/.certs/ThawtePremiumServerCA.pem .ThawtePremiumServerCA.pem

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

