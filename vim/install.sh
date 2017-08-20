printf "Installing vim-gtk"
apt-get install -y vim-gtk

# required for translating python to ipython
printf "Installing notedown"
pip install notedown

printf "Installing vim-plug + plugins \n\n\n"

curl -fLo $HOME/.vim/autoload/plug.vim --create-dirs \
  https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim

vim +PlugInstall +qall
