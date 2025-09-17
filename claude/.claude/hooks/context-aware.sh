#!/bin/bash
# Context-aware hook for Great Question development
# Uses git context to suggest appropriate subagents

# Check if we're in a git repository
if ! git rev-parse --is-inside-work-tree >/dev/null 2>&1; then
  exit 1
fi

USER_PROMPT="$1"
CURRENT_BRANCH=$(git branch --show-current 2>/dev/null || echo "")

# Branch-based context
if [[ "$CURRENT_BRANCH" =~ (feature|feat)/ ]]; then
  if [[ "$USER_PROMPT" =~ (implement|add|create|build) ]]; then
    echo "🚀 Feature branch with implementation request - auto-launching developer agent..."
    echo "SUBAGENT: developer"
    exit 0
  fi
elif [[ "$CURRENT_BRANCH" =~ (fix|hotfix|bug)/ ]]; then
  if [[ "$USER_PROMPT" =~ (debug|investigate|analyze|why) ]]; then
    echo "🔧 Bug fix branch with debugging request - auto-launching debugger agent..."
    echo "SUBAGENT: debugger"
    exit 0
  fi
fi

# Check current working directory for context clues
PWD_CONTEXT=$(pwd)
if [[ "$PWD_CONTEXT" =~ /spec/ && "$USER_PROMPT" =~ (fix|debug|test) ]]; then
  echo "🧪 In spec directory with debugging request - auto-launching debugger agent..."
  echo "SUBAGENT: debugger"
  exit 0
fi

if [[ "$PWD_CONTEXT" =~ /app/javascript/ && "$USER_PROMPT" =~ (review|check|analyze) ]]; then
  echo "⚛️ In frontend directory with review request - auto-launching code-reviewer..."
  echo "SUBAGENT: code-reviewer"
  exit 0
fi

# No specific context detected, let normal processing continue
exit 1

