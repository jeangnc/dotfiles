# read man pages on nvim
export MANPAGER='nvim +Man!'
export MANWIDTH=999

eval "$(/opt/homebrew/bin/brew shellenv)"

# ruby
eval "$(rbenv init - --no-rehash zsh)"
