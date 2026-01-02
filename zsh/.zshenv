export GIT_DISCOVERY_ACROSS_FILESYSTEM=1
export OBJC_DISABLE_INITIALIZE_FORK_SAFETY=YES

# read man pages on nvim
export MANPAGER='nvim +Man!'
export MANWIDTH=999

##
## path
##

# rbenv
export PATH="$HOME/.rbenv/bin:$PATH"

# node
export PATH="/opt/homebrew/opt/node@22/bin:$PATH"

# go
export GOPATH="$HOME/go"
export PATH="$GOPATH/bin:$PATH"

#pipx
export PATH="$HOME/.local/bin:$PATH" 

#postgresql
export PATH="/opt/homebrew/opt/postgresql@18/bin:$PATH"

# qlty
export QLTY_INSTALL="$HOME/.qlty"
export PATH="$QLTY_INSTALL/bin:$PATH"

# ruby
# enables YJIT
export RUBY_YJIT_ENABLE=1
