# setup homebrew
eval "$(/opt/homebrew/bin/brew shellenv)"

# setup rbenv
eval "$(rbenv init - --no-rehash zsh)"

# setup fzf
source <(fzf --zsh)

# macOS defaults
defaults write -g ApplePressAndHoldEnabled -bool false
defaults write com.apple.dock no-bouncing -bool TRUE
ulimit -n 4096

# aliases and local configs
[ -f "$HOME/.aliases" ] && source "$HOME/.aliases"
[ -f "$HOME/.zprofile.local" ] && source "$HOME/.zprofile.local"
