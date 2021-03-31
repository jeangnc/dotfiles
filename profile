export GIT_DISCOVERY_ACROSS_FILESYSTEM=1

# kubernetes
export KUBE_EDITOR=vim
export KUBE_NAMESPACE=core

# go
export GOROOT=/usr/lib/go
export GOPATH=$HOME/go
export PATH=$PATH:$GOROOT/bin:$GOPATH/bin

[ -f "$HOME/.Xresources" ] && xrdb -merge  "$HOME/.Xresources"
[ -f "$HOME/.aliases" ] && source "$HOME/.aliases"
[ -f "$HOME/.profile.local" ] && source "$HOME/.profile.local"
