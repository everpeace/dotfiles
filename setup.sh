ln -s $HOME/dotfiles/.bash_profile $HOME/.bash_profile
ln -s $HOME/dotfiles/.gitignore $HOME/.gitignore
ln -s $HOME/dotfiles/.vim $HOME/.vim
ln -s $HOME/dotfiles/.vimrc $HOME/.vimrc
ln -s $HOME/dotfiles/.zshrc $HOME/.zshrc

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
  # git config --global core.excludesfile "$HOME/.gitignore"
  ln -s $HOME/dotfiles/.gitconfig $HOME/.gitconfig
else echo "no git"
fi

