export GIT_DISCOVERY_ACROSS_FILESYSTEM=1
export VIM_VERSION=$( [ -x "$(command -v nvim)" ] && echo "nvim" || echo "vim" )
export KUBE_EDITOR=$VIM_VERSION
export EDITOR=$VIM_VERSION
export OBJC_DISABLE_INITIALIZE_FORK_SAFETY=YES

# go
export GOROOT=/usr/local/go
export GOPATH=$HOME/.go
export PATH=$PATH:$HOME/.local/bin:$GOROOT/bin:$GOPATH/bin

# NVM
export NVM_DIR="$HOME/.nvm"
[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"  # This loads nvm
[ -s "$NVM_DIR/bash_completion" ] && \. "$NVM_DIR/bash_completion"  # This loads nvm bash_completion

# rbenv
export PATH="$HOME/.rbenv/bin:$PATH"
eval "$(rbenv init -)"

# macOS defaults
defaults write -g ApplePressAndHoldEnabled -bool false
ulimit -n 4096

# aliases and local configs
[ -f "$HOME/.Xresources" ] && xrdb -merge  "$HOME/.Xresources"
[ -f "$HOME/.aliases" ] && source "$HOME/.aliases"
[ -f "$HOME/.profile.local" ] && source "$HOME/.profile.local"
