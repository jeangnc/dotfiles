# git
alias gps='git push origin "$(git_current_branch)"'
alias gpl='git pull origin "$(git_current_branch)"'
alias gbd='function _gbd() { git branch -D "$1" && git push origin --delete "$1"; }; _gbd'

# git worktree
unalias gwt 2>/dev/null
gwt() {
  local branch="$1"
  if [[ -z "$branch" ]]; then
    echo "Usage: gwt <branch>" >&2
    return 1
  fi
  local repo=$(basename "$(git rev-parse --show-toplevel)")
  local wt_path="/private/tmp/git-worktrees/$repo/$branch"
  if [[ ! -d "$wt_path" ]]; then
    git worktree prune
    git worktree add "$wt_path" "$branch" || return 1
  fi
  cd "$wt_path"
}

gwte() {
  gwt "$1" && $EDITOR .
}

alias gwtc='rm -rf /tmp/git-worktrees && git worktree prune'

# "git update"
alias gu='git checkout -q main && git pull && git for-each-ref refs/heads/ "--format=%(refname:short)" | while read branch; do mergeBase=$(git merge-base main $branch) && [[ $(git cherry main $(git commit-tree $(git rev-parse "$branch^{tree}") -p $mergeBase -m _)) == "-"* ]] && git branch -D $branch; done'

# github
alias ghpo='gh pr view --web'
alias ghpc='gh pr checks --json name,state,link'
alias ghpcf='gh pr checks --json state,link --jq ".[] | select(.state==\"FAILURE\") | .link"'
alias ghps='gh pr status'

# editor
alias vi="nvim"
alias vim="nvim"

# json
alias jf="jq -C . | less -R"
alias je="jq -c '.[]'"

alias o="open"
alias xo="xargs open"
alias oi="kitten icat"

# python
alias pip="python3 -m pip"
alias venv="python3 -m venv .venv && source .venv/bin/activate"

alias wt="CLICOLOR_FORCE=1 watch --color"


# misc
alias dotf="~/.dotfiles"
alias orgf="~/.orgfiles"
alias ka="caffeinate -disu"
