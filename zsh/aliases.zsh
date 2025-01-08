# git
alias gps='git push origin "$(git_current_branch)"'
alias gpl='git pull origin "$(git_current_branch)"'
alias gbd='function _gbd() { git branch -d "$1" && git push origin --delete "$1"; }; _gbd'

# "git update"
alias gu='git checkout -q main && git pull && git for-each-ref refs/heads/ "--format=%(refname:short)" | while read branch; do mergeBase=$(git merge-base main $branch) && [[ $(git cherry main $(git commit-tree $(git rev-parse "$branch^{tree}") -p $mergeBase -m _)) == "-"* ]] && git branch -D $branch; done'

# editor
alias vi="nvim"
alias vim="nvim"

# json
alias jf="jq -C . | less -R"
alias je="jq -c '.[]'"

# misc
alias dof="~/.dotfiles"
