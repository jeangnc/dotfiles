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

# alacritty
ALACRITTY_CONFIG_FOLDER=$HOME/.config/alacritty/
ALACRITTY_CONFIG_FILE=$ALACRITTY_CONFIG_FOLDER/alacritty.yml
mkdir -p $ALACRITTY_CONFIG_FOLDER

if [[ "$OSTYPE" == "linux-gnu"* ]]; then
    ln -sf $DOTFILES/alacritty/.alacritty.linux.yml $ALACRITTY_CONFIG_FILE
elif [[ "$OSTYPE" == "darwin"* ]]; then
    # Mac OSX
    ln -sf $DOTFILES/alacritty/.alacritty.mac.yml $ALACRITTY_CONFIG_FILE
else
    { echo "Unkown SO"; exit 1; }
fi

# vim
mkdir -p $HOME/.vim/swapfiles

rm -rf $HOME/.vim/ftplugin && ln -s $DOTFILES/vim/languages $HOME/.vim/ftplugin
curl -fLo ~/.vim/autoload/plug.vim --create-dirs \
    https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim

vim +PlugInstall

# git
rm -rf $HOME/.gitignore && ln -s $DOTFILES/git/.gitignore $HOME/.gitignore

# fonts
mkdir -p $HOME/.fonts/{truetype,opentype}/
cp $DOTFILES/fonts/*.ttf $HOME/.fonts/truetype/ 2>/dev/null
cp $DOTFILES/fonts/*.otf $HOME/.fonts/opentype/ 2>/dev/null
fc-cache -fv $HOME/.fonts

