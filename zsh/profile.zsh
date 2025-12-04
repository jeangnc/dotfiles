# macOS defaults
defaults write -g ApplePressAndHoldEnabled -bool false
ulimit -n 4096

# setup homebrew
eval "$(/opt/homebrew/bin/brew shellenv)"

# setup rbenv
eval "$(rbenv init - --no-rehash zsh)"

# setup fzf
source <(fzf --zsh)

# qlty completions
[ -s "/opt/homebrew/share/zsh/site-functions/_qlty" ] && source "/opt/homebrew/share/zsh/site-functions/_qlty"

# cargo
. "$HOME/.cargo/env"
