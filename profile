export GIT_DISCOVERY_ACROSS_FILESYSTEM=1

export GOROOT=/usr/lib/go
export GOPATH=$HOME/go
export PATH=$PATH:$GOROOT/bin:$GOPATH/bin

[ -f "$HOME/.Xresources" ] && xrdb -merge  "$HOME/.Xresources"
[ -f "$HOME/.aliases" ] && source "$HOME/.aliases"
[ -f "$HOME/.profile.local" ] && source "$HOME/.profile.local"
