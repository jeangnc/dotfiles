DOTFILES=$(cd "$(dirname "$0")" ; pwd -P)

# symlinks
ln -sf $DOTFILES/zsh/.zshrc $HOME/.zshrc
ln -sf $DOTFILES/vim/.vimrc $HOME/.vimrc
ln -sf $DOTFILES/tmux/.tmux.conf $HOME/.tmux.conf
ln -sf $DOTFILES/bash/.bashrc $HOME/.bashrc
ln -sf $DOTFILES/.aliases $HOME/.aliases
ln -sf $DOTFILES/.profile $HOME/.profile

touch $HOME/.aliases.local
touch $HOME/.profile.local

# vim
mkdir -p $HOME/.vim/swapfiles

rm -rf $HOME/.vim/ftplugin && ln -s $DOTFILES/vim/languages $HOME/.vim/ftplugin
curl -fLo ~/.vim/autoload/plug.vim --create-dirs \
    https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim

vim +PlugInstall

# git
rm -rf $HOME/.gitignore_global && ln -s $DOTFILES/git/.gitignore_global $HOME/.gitignore_global

# fonts
mkdir -p $HOME/.fonts/{truetype,opentype}/
cp $DOTFILES/fonts/*.ttf $HOME/.fonts/truetype/ 2>/dev/null
cp $DOTFILES/fonts/*.otf $HOME/.fonts/opentype/ 2>/dev/null
fc-cache -fv $HOME/.fonts

