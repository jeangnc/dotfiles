USER=$(whoami)
HOME=/home/$USER
DOTFILES=/$HOME/.dotfiles

echo "Running install scripts\n\n"

sudo $DOTFILES/zsh/install.sh
sudo $DOTFILES/vim/install.sh
sudo $DOTFILES/tmux/install.sh


echo "Creating symlinks\n\n"

rm $HOME/.zshrc && ln -s $DOTFILES/zsh/conf $HOME/.zshrc
rm $HOME/.vimrc && ln -s $DOTFILES/vim/conf $HOME/.vimrc
rm $HOME/.tmux.conf && ln -s $DOTFILES/tmux/conf $HOME/.tmux.conf

