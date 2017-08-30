USER=$(whoami)

printf "Installing vim-gtk"
sudo apt-get install -y vim-gtk

printf "Installing vim-plug + plugins \n\n\n"

curl -fLo $HOME/.vim/autoload/plug.vim --create-dirs \
  https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim

vim +PlugInstall +qall
