---
description: Open a PR using the repo template with auto-generated content
tools:
  - Bash(gh pr create:*)
  - Bash(git diff:*)
  - Bash(git log:*)
  - Bash(git status:*)
---

1. Check git status and review committed changes (against main branch)
1. Ignore uncommited changes.
1. Generate meaningful PR title from commit messages and changes
1. Use repo's PR template from `.github/pull_request_template.md` if it exists
1. Auto-fill template sections based on the changes:
   - Description: Summarize what changed and why
   - Risk/Risk Mitigation: Analyze potential issues
   - Testing: Include relevant test commands from CLAUDE.md
1. Create PR in "Ready to review" mode by default
1. Provide PR URL for review
