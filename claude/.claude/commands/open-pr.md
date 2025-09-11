---
description: Open a PR using the repo template with auto-generated content
tools:
  - Bash(gh pr create:*)
  - Bash(git diff:*)
  - Bash(git log:*)
  - Bash(git status:*)
---

1. Check git status and review committed changes since main branch
2. Generate meaningful PR title from commit messages and changes
3. Use repo's PR template from `.github/pull_request_template.md` if it exists
4. Auto-fill template sections based on the changes:
   - Description: Summarize what changed and why
   - Risk/Risk Mitigation: Analyze potential issues
   - Testing: Include relevant test commands from CLAUDE.md
5. Create PR in draft mode by default (safer approach)
6. Provide PR URL for review
