# git
alias gps='git push origin "$(git_current_branch)"'
alias gpl='git pull origin "$(git_current_branch)"'

unalias gbd 2>/dev/null
gbd() {
  local branch="$1"
  if [[ -z "$branch" ]]; then
    echo "Usage: gbd <branch>" >&2
    return 1
  fi
  git branch -D "$branch" && git push origin --delete "$branch"
}

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

# Safe prune: drop dead entries + remove worktrees that are clean AND fully pushed.
gwtp() {
  local main
  main=$(git rev-parse --show-toplevel) || return 1
  git worktree prune
  git worktree list --porcelain | awk '/^worktree /{print $2}' | while read -r wt; do
    [[ "$wt" == "$main" ]] && continue
    if [[ -n "$(git -C "$wt" status --porcelain)" ]]; then
      echo "skip (uncommitted): $wt" >&2
      continue
    fi
    local upstream=""
    upstream=$(git -C "$wt" rev-parse --abbrev-ref --symbolic-full-name '@{upstream}' 2>/dev/null) || true
    if [[ -z "$upstream" ]]; then
      echo "skip (no upstream): $wt" >&2
      continue
    fi
    if [[ -n "$(git -C "$wt" rev-list "$upstream"..HEAD)" ]]; then
      echo "skip (unpushed):    $wt" >&2
      continue
    fi
    git worktree remove "$wt" && echo "removed:            $wt"
  done
  git worktree prune
}

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

# node
# Usage: npr [patch|minor|major|prerelease]  (default: patch)
npr() {
  pnpm version "${1:-patch}" && git push --follow-tags
}

alias wt="CLICOLOR_FORCE=1 watch --color"


# misc
alias dotf="~/.dotfiles"
alias orgf="~/.orgfiles"
alias ka="caffeinate -disu"
