USER=$(whoami)
HOME=/home/$USER
DOTFILES=$HOME/.dotfiles

echo "Running install scripts\n\n"

sudo $DOTFILES/zsh/install.sh
sudo $DOTFILES/vim/install.sh
sudo $DOTFILES/tmux/install.sh


echo "Creating symlinks\n\n"

rm -rf $HOME/.zshrc && ln -s $DOTFILES/zsh/conf $HOME/.zshrc
rm -rf $HOME/.vimrc && ln -s $DOTFILES/vim/conf $HOME/.vimrc
rm -rf $HOME/.tmux.conf && ln -s $DOTFILES/tmux/conf $HOME/.tmux.conf

echo "Installing zsh plugins"

for i in $(ls $DOTFILES/zsh/oh-my-zsh/plugins); do
  rm -rf $ZSH/plugins/$i && ln -s $DOTFILES/zsh/oh-my-zsh/plugins/$i $ZSH/plugins/
done
