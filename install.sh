DOTFILES=`realpath $(dirname "$0")`

echo "Creating symlinks"

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

rm -rf $HOME/.vim/ftplugin && ln -s $DOTFILES/vim/languages $HOME/.vim/ftplugin
