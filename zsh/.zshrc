export ZSH="$HOME/.oh-my-zsh"

# homebrew completions (must precede compinit in oh-my-zsh.sh)
fpath=("/opt/homebrew/share/zsh/site-functions" $fpath)

ZSH_THEME="lambda"
ZSH_CUSTOM="$HOME/.config/zsh"

# plugins
ZSH_DOTENV_PROMPT=false
ZSH_DOTENV_FILE=.env.local
plugins=(git rails bundler docker-compose dotenv)
source $ZSH/oh-my-zsh.sh

# rbenv (interactive function + completion; PATH lives in .zshenv)
eval "$(rbenv init - --no-rehash zsh)"

# fzf
source <(fzf --zsh)

# direnv
eval "$(direnv hook zsh)"

# qlty completion
[ -s "/opt/homebrew/share/zsh/site-functions/_qlty" ] && source "/opt/homebrew/share/zsh/site-functions/_qlty"


# pnpm
export PNPM_HOME="/Users/jeangnc/Library/pnpm"
case ":$PATH:" in
  *":$PNPM_HOME:"*) ;;
  *) export PATH="$PNPM_HOME:$PATH" ;;
esac
# pnpm end
