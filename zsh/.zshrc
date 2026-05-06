export ZSH="$HOME/.oh-my-zsh"

ulimit -n 4096

ZSH_THEME="lambda"
ZSH_CUSTOM="$HOME/.config/zsh"

# plugins
ZSH_DOTENV_PROMPT=false
ZSH_DOTENV_FILE=.env.local
plugins=(git rails bundler docker-compose dotenv)
source $ZSH/oh-my-zsh.sh
