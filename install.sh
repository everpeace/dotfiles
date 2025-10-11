#! /usr/bin/env zsh

case $(uname) in
  "Darwin")
    LN_OPT="-hfs";;
  "Linux")
    LN_OPT="-fsT";;
esac

function install {
  if [ $# -eq 1 ];then
    _fromfilename=$1
    _tofilename=$1
  fi
  if [ $# -eq 2 ];then
    _fromfilename=$1
    _tofilename=$2
  fi

  if [ $# -eq 1 ] || [ $# -eq 2 ];then
    mkdir -p "$(dirname "${TO}/${_tofilename}")"
    echo ln "$LN_OPT" "$FROM/$_fromfilename" "$TO/$_tofilename"
    ln "$LN_OPT" "$FROM/$_fromfilename" "$TO/$_tofilename"
  fi
}

function install_all {
  local dir=$1
  mkdir -p "${TO}/${dir}"
  for item in "${dir}"/**/*; do
    [ -f "${item}" ] && mkdir -p "${TO}/$(dirname "${item}")" && install "${item}"
  done
}

# スクリプトのある場所
FROM="$(cd "$(dirname "${0}")" && pwd)"
# リンクを張る場所
TO="${HOME}"

install .zshrc
install .python-version
install_all .config
install_all bin
install_all .gnupg && chmod 700 "${TO}/.gnupg"
install_all .ssh && chmod 700 "${TO}/.ssh"
install Library/LaunchAgents/com.everpeace.atuinserver.plist

# vim-plug
[ -f ~/.vim/autoload/plug.vim ] || curl -fLo ~/.vim/autoload/plug.vim --create-dirs \
    https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim
vim +'PlugInstall --sync' +qa

defaults write -g InitialKeyRepeat -int 11
defaults write -g KeyRepeat -int 1
