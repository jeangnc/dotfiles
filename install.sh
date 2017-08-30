USER=$(whoami)
HOME=/home/$USER
DOTFILES=$HOME/.dotfiles

echo "Running install scripts\n\n"

$DOTFILES/zsh/install.sh
$DOTFILES/vim/install.sh
$DOTFILES/tmux/install.sh

echo "Creating symlinks\n\n"

rm -rf $HOME/.zshrc && ln -s $DOTFILES/zsh/conf $HOME/.zshrc
rm -rf $HOME/.vimrc && ln -s $DOTFILES/vim/conf $HOME/.vimrc
rm -rf $HOME/.tmux.conf && ln -s $DOTFILES/tmux/conf $HOME/.tmux.conf

echo "Installing custom vim plugins"

#for i in $(ls $DOTFILES/vim/plugins); do
#  rm -rf $HOME/.vim/plugins/$i && ln -s $DOTFILES/vim/plugins/$i $HOME/.vim/plugins/
#done

printf "Setting up vim filetype plugin"
rm -rf $HOME/.vim/ftplugin && ln -s $DOTFILES/vim/languages $HOME/.vim/ftplugin

echo "Installing zsh plugins"

for i in $(ls $DOTFILES/zsh/oh-my-zsh/plugins); do
  rm -rf $ZSH/plugins/$i && ln -s $DOTFILES/zsh/oh-my-zsh/plugins/$i $ZSH/plugins/
done
