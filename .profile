export GIT_DISCOVERY_ACROSS_FILESYSTEM=1
export VIM_VERSION=$( [ -x "$(command -v vimx)" ] && echo "vimx" || echo "vim" )

# kubernetes
export KUBE_EDITOR=$VIM_VERSION

# go
export GOROOT=/usr/local/go
export GOPATH=$HOME/.go
export PATH=$PATH:$HOME/.local/bin:$GOROOT/bin:$GOPATH/bin

[ -f "$HOME/.Xresources" ] && xrdb -merge  "$HOME/.Xresources"
[ -f "$HOME/.aliases" ] && source "$HOME/.aliases"
[ -f "$HOME/.profile.local" ] && source "$HOME/.profile.local"
