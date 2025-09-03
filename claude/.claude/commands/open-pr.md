---
description: Open a PR using the repo template
---

1. Use the `code-reviewer` subagent.
1. Only consider what's pushed, ignore any uncommited changes.
1. Use the repo’s PR template from `.github/pull_request_template.md` (if it exists).
1. Prepend `"Hello :wave:"` as the first line in the PR body.
1. Use `gh pr create` to open a PR.
