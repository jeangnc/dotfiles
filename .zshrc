export LANG=en_US.UTF-8
export ZSH="$HOME/.oh-my-zsh"

if [[ -n $SSH_CONNECTION ]]; then
  export EDITOR='vim'
else
  export EDITOR='nvim'
fi

ZSH_THEME="lambda"
ZSH_CUSTOM="$HOME/.config/zsh"

# plugins
ZSH_DOTENV_PROMPT=false
plugins=(git rails bundler docker-compose last-working-dir dotenv)
source $ZSH/oh-my-zsh.sh
