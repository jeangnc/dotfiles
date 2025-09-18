#!/bin/bash
# Post-tool-call hook - Claude-powered intelligent follow-up actions
# Analyzes tool results to suggest or auto-launch appropriate agents

CLAUDE_DIR="$HOME/.dotfiles/claude/.claude"
STATE_FILE="$CLAUDE_DIR/.agent_state"

# Function to suggest agent via Claude analysis
suggest_agent() {
  local context="$1"
  local escaped_context=$(echo "$context" | sed 's/"/\\"/g')

  local analysis_prompt="Based on this tool execution result, should I automatically launch a specialized agent for follow-up?

  TOOL: $TOOL_NAME
  RESULT SUMMARY: \"$escaped_context\"

  Available agents: debugger, code-reviewer, developer, data-scientist, solution-architect, technical-support, dba, principal-engineer, sre

  Respond with ONLY the agent name if auto-launch is recommended (>90% confidence), otherwise 'none'.

  Auto-launch criteria:
  - code-reviewer: After significant code changes, PR creation, or style violations
  - debugger: After errors, test failures, or broken functionality
  - developer: When partial implementation needs completion
  - data-scientist: After SQL operations or data analysis needs
  - sre: After monitoring/alerting setup or reliability issues"

  local suggested_agent=$(echo "$analysis_prompt" | claude --max-tokens 20 --temperature 0.1 2>/dev/null | tr -d '\n' | tr -d ' ')
  echo "$suggested_agent"
}

# Auto-launch for significant code changes
if [[ "$TOOL_NAME" =~ ^(Edit|Write|MultiEdit)$ ]]; then
  if [[ ${#TOOL_RESULT} -gt 100 || "$TOOL_RESULT" =~ (class|def|function|component|export|module) ]]; then
    echo "🔍 Significant code changes detected - auto-launching code-reviewer..."
    echo "code-reviewer" >"$STATE_FILE"
    echo "SUBAGENT: code-reviewer"
    exit 0
  fi
fi

# Analyze bash command results
if [[ "$TOOL_NAME" == "Bash" ]]; then
  # Auto-launch debugger for clear errors
  if [[ "$TOOL_RESULT" =~ (FAILED|ERROR|Exception|TypeError|SyntaxError|Traceback|rspec.*failures|jest.*failed) ]]; then
    echo "🔧 Errors detected - auto-launching debugger agent..."
    echo "debugger" >"$STATE_FILE"
    echo "SUBAGENT: debugger"
    exit 0
  fi

  # Auto-launch code-reviewer for PR creation
  if [[ "$TOOL_RESULT" =~ (gh pr create|pull request created|Created pull request) ]]; then
    echo "🚀 PR created - auto-launching code-reviewer..."
    echo "code-reviewer" >"$STATE_FILE"
    echo "SUBAGENT: code-reviewer"
    exit 0
  fi

  # Use Claude to analyze more complex scenarios
  if [[ ${#TOOL_RESULT} -gt 50 ]]; then
    local suggested_agent=$(suggest_agent "${TOOL_RESULT:0:500}")
    case "$suggested_agent" in
    "code-reviewer" | "debugger" | "developer" | "data-scientist" | "sre")
      echo "🤖 Claude suggests launching $suggested_agent agent for follow-up..."
      echo "$suggested_agent" >"$STATE_FILE"
      echo "SUBAGENT: $suggested_agent"
      exit 0
      ;;
    esac
  fi
fi
