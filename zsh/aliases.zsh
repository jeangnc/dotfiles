# git
alias gps='git push origin "$(git_current_branch)"'
alias gpl='git pull origin "$(git_current_branch)"'
alias gbd='function _gbd() { git branch -d "$1" && git push origin --delete "$1"; }; _gbd'

## git sync
alias gs="git checkout main && git pull && git branch --merged | grep -v '\*' | grep -v 'main' | xargs -n 1 git branch -d"


# editor
alias vi="nvim"
alias vim="nvim"

# json
alias jf="jq -C . | less -R"
alias je="jq -c '.[]'"

# misc
alias dof="~/.dotfiles"
