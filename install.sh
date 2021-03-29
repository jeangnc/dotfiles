DOTFILES=`realpath $(dirname "$0")`

# symlinks
ln -sf $DOTFILES/zsh/zshrc $HOME/.zshrc
ln -sf $DOTFILES/vim/vimrc $HOME/.vimrc
ln -sf $DOTFILES/tmux/tmuxconf $HOME/.tmux.conf
ln -sf $DOTFILES/bash/bashrc $HOME/.bashrc
ln -sf $DOTFILES/aliases $HOME/.aliases
ln -sf $DOTFILES/profile $HOME/.profile

rm -rf $HOME/.vim/ftplugin && ln -s $DOTFILES/vim/languages $HOME/.vim/ftplugin

touch $HOME/.aliases.local
touch $HOME/.profile.local

# git
rm -rf $HOME/.gitignore_global && ln -s $DOTFILES/git/gitignore_global $HOME/.gitignore_global

# fonts
mkdir -p $HOME/.fonts/{truetype,opentype}/
cp $DOTFILES/fonts/*.ttf $HOME/.fonts/truetype/ 2>/dev/null
cp $DOTFILES/fonts/*.otf $HOME/.fonts/opentype/ 2>/dev/null
fc-cache -fv $HOME/.fonts

