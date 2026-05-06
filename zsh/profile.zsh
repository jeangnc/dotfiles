# fzf
source <(fzf --zsh)

# qlty completions
[ -s "/opt/homebrew/share/zsh/site-functions/_qlty" ] && source "/opt/homebrew/share/zsh/site-functions/_qlty"

# cargo
. "$HOME/.cargo/env"
