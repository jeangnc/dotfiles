DOTFILES=`realpath $(dirname "$0")`

echo "Creating symlinks"
ln -sf $DOTFILES/zsh/zshrc $HOME/.zshrc
ln -sf $DOTFILES/vim/vimrc $HOME/.vimrc
ln -sf $DOTFILES/tmux/tmuxconf $HOME/.tmux.conf
ln -sf $DOTFILES/system/bashrc $HOME/.bashrc
ln -sf $DOTFILES/system/aliases $HOME/.aliases
ln -sf $DOTFILES/system/profile $HOME/.profile

rm -rf $HOME/.zshrc && ln -s $DOTFILES/zsh/zshrc $HOME/.zshrc
rm -rf $HOME/.vimrc && ln -s $DOTFILES/vim/vimrc $HOME/.vimrc
rm -rf $HOME/.tmux.conf && ln -s $DOTFILES/tmux/tmuxconf $HOME/.tmux.conf
rm -rf $HOME/.bashrc && ln -s $DOTFILES/system/bashrc $HOME/.bashrc
rm -rf $HOME/.aliases && ln -s $DOTFILES/system/aliases $HOME/.aliases
rm -rf $HOME/.profile && ln -s $DOTFILES/system/profile $HOME/.profile

# git
rm -rf $HOME/.gitignore_global && ln -s $DOTFILES/git/gitignore_global $HOME/.gitignore_global

echo "Installing fonts"
mkdir -p $HOME/.fonts/{truetype,opentype}/
cp $DOTFILES/fonts/*.ttf $HOME/.fonts/truetype/
cp $DOTFILES/fonts/*.otf $HOME/.fonts/opentype/
fc-cache -fv $HOME/.fonts

echo  "Setting up vim filetype plugin"

ln -sf $DOTFILES/vim/languages $HOME/.vim/ftplugin
