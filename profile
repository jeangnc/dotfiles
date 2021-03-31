export GIT_DISCOVERY_ACROSS_FILESYSTEM=1
export VIM=$( [ -x "$(command -v vimx)" ] && echo "vimx" || echo "vim" )

# kubernetes
export KUBE_EDITOR=$VIM
export KUBE_NAMESPACE=core

# go
export GOROOT=/usr/local/go
export GOPATH=$HOME/go
export PATH=$PATH:$GOROOT/bin:$GOPATH/bin

[ -f "$HOME/.Xresources" ] && xrdb -merge  "$HOME/.Xresources"
[ -f "$HOME/.aliases" ] && source "$HOME/.aliases"
[ -f "$HOME/.profile.local" ] && source "$HOME/.profile.local"
