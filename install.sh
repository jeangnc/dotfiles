DOTFILES=`realpath $(dirname "$0")`

echo "Creating symlinks"

rm -rf $HOME/.zshrc && ln -s $DOTFILES/zsh/zshrc $HOME/.zshrc
rm -rf $HOME/.vimrc && ln -s $DOTFILES/vim/vimrc $HOME/.vimrc
rm -rf $HOME/.tmux.conf && ln -s $DOTFILES/tmux/tmuxconf $HOME/.tmux.conf
rm -rf $HOME/.bashrc && ln -s $DOTFILES/system/bashrc $HOME/.bashrc
rm -rf $HOME/.aliases && ln -s $DOTFILES/system/aliases $HOME/.aliases
rm -rf $HOME/.profile && ln -s $DOTFILES/system/profile $HOME/.profile


echo  "Setting up vim filetype plugin"

rm -rf $HOME/.vim/ftplugin && ln -s $DOTFILES/vim/languages $HOME/.vim/ftplugin
