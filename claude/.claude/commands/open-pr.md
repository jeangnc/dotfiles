---
description: Open a PR using the repo template
tools:
  - Bash(gh pr create:*)
  - Bash(git diff:*)
  - Bash(git log:*)
  - Bash(git status:*)
---

1. Look at the commited diff with the head branch
1. Use the repo’s PR template from `.github/pull_request_template.md` (if it exists).
1. Prepend `"Hello :wave:"` as the first line in the PR body.
1. Use `gh pr create` to open a PR.
