##
## env
##

export LANG=en_US.UTF-8

if [[ -n $SSH_CONNECTION ]]; then
  export EDITOR='vim'
else
  export EDITOR='nvim'
fi

export CLAUDE_CODE_NO_FLICKER=1
export GIT_DISCOVERY_ACROSS_FILESYSTEM=1
export OBJC_DISABLE_INITIALIZE_FORK_SAFETY=YES

# read man pages on nvim
export MANPAGER='nvim +Man!'
export MANWIDTH=999

# ruby (YJIT)
export RUBY_YJIT_ENABLE=1

##
## path
##

# homebrew
eval "$(/opt/homebrew/bin/brew shellenv)"

# rbenv
export PATH="$HOME/.rbenv/bin:$PATH"
eval "$(rbenv init - --no-rehash zsh)"

# node
export PATH="/opt/homebrew/opt/node@22/bin:$PATH"

# go
export GOPATH="$HOME/go"
export PATH="$GOPATH/bin:$PATH"

# pipx
export PATH="$HOME/.local/bin:$PATH"

# postgresql
export PATH="/opt/homebrew/opt/postgresql@18/bin:$PATH"

# qlty
export QLTY_INSTALL="$HOME/.qlty"
export PATH="$QLTY_INSTALL/bin:$PATH"
