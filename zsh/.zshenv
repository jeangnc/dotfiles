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

typeset -U path PATH

##
## path
##

# homebrew
export HOMEBREW_PREFIX="/opt/homebrew"
export HOMEBREW_CELLAR="/opt/homebrew/Cellar"
export HOMEBREW_REPOSITORY="/opt/homebrew"
export PATH="/opt/homebrew/bin:/opt/homebrew/sbin:$PATH"
export MANPATH="/opt/homebrew/share/man${MANPATH:+:$MANPATH}"
export INFOPATH="/opt/homebrew/share/info${INFOPATH:+:$INFOPATH}"

# rbenv
export PATH="$HOME/.rbenv/shims:$HOME/.rbenv/bin:$PATH"

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

# cargo
export PATH="$HOME/.cargo/bin:$PATH"

# local overrides
[ -f "$HOME/.zshenv.local" ] && source "$HOME/.zshenv.local"
