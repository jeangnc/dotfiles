---
description: Fix a Linear ticket using multiple agents and systematic approach
---

Fix Linear ticket: $1 using a comprehensive approach:

1. Use `/contextualize-ticket` to get context about the issue
1. Use `/investigate-ticket` if more information is needed
1. Use the developer subagent to implement the fix
1. Use the code-reviewer subagent to review the implemented changes
1. Run tests and ensure quality checks pass
1. Use `/contextualize-ticket` to verify the fix addresses the original issue
1. Use `/open-pr` to create a pull request with the solution
