# setup homebrew
eval "$(/opt/homebrew/bin/brew shellenv)"

# setup rbenv
eval "$(rbenv init - --no-rehash zsh)"

# exports
export GIT_DISCOVERY_ACROSS_FILESYSTEM=1
export OBJC_DISABLE_INITIALIZE_FORK_SAFETY=YES
export PATH="/opt/homebrew/opt/node@22/bin:$PATH"

# read man pages on nvim
export MANPAGER='nvim +Man!'
export MANWIDTH=999

# macOS defaults
defaults write -g ApplePressAndHoldEnabled -bool false
defaults write com.apple.dock no-bouncing -bool TRUE
ulimit -n 4096

# aliases and local configs
[ -f "$HOME/.aliases" ] && source "$HOME/.aliases"
[ -f "$HOME/.zprofile.local" ] && source "$HOME/.zprofile.local"
