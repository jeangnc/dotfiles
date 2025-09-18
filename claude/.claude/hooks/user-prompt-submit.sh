#!/bin/bash
# User prompt submit hook - Claude-powered intelligent agent selection
# Uses Claude to analyze user intent and select the most appropriate agent

USER_PROMPT="$1"
CLAUDE_DIR="$HOME/.dotfiles/claude/.claude"

# Get available agents
AGENTS_LIST=$(ls "$CLAUDE_DIR/agents/"*.md 2>/dev/null | xargs -I {} basename {} .md | tr '\n' ', ' | sed 's/, $//')

# Escape quotes in user prompt for JSON
ESCAPED_PROMPT=$(echo "$USER_PROMPT" | sed 's/"/\\"/g')

# Create the analysis prompt
ANALYSIS_PROMPT="Analyze this user request and determine the most appropriate specialized agent:

USER REQUEST: \"$ESCAPED_PROMPT\"

AVAILABLE AGENTS: $AGENTS_LIST

Respond with ONLY the agent name (e.g., 'debugger', 'code-reviewer', etc.) if you're confident (>80%) that a specialized agent would handle this better than the general assistant. If no specialized agent is clearly better, respond with 'general'.

Consider:
- debugger: Fixing bugs, troubleshooting errors, investigating failures
- code-reviewer: Reviewing code quality, security, best practices
- developer: Writing new features, implementing functionality, TDD/BDD
- data-scientist: SQL queries, data analysis, BigQuery operations
- solution-architect: System design, architecture planning, scalability
- technical-support: Production issues, incident analysis, deep investigations
- dba: Database optimization, migrations, schema changes
- principal-engineer: Strategic planning, cross-team initiatives, roadmaps
- sre: Reliability, monitoring, incident response, observability"

# Use Claude API to determine the best agent
SELECTED_AGENT=$(echo "$ANALYSIS_PROMPT" | claude --max-tokens 50 --temperature 0.1 2>/dev/null | tr -d '\n' | tr -d ' ')

# Validate the response and launch agent if appropriate
case "$SELECTED_AGENT" in
"debugger")
  echo "🔧 Claude detected debugging task - launching debugger agent..."
  echo "SUBAGENT: debugger"
  exit 0
  ;;
"code-reviewer")
  echo "👀 Claude detected code review task - launching code-reviewer agent..."
  echo "SUBAGENT: code-reviewer"
  exit 0
  ;;
"developer")
  echo "🛠️ Claude detected development task - launching developer agent..."
  echo "SUBAGENT: developer"
  exit 0
  ;;
"data-scientist")
  echo "📊 Claude detected data analysis task - launching data-scientist agent..."
  echo "SUBAGENT: data-scientist"
  exit 0
  ;;
"solution-architect")
  echo "🏗️ Claude detected architecture task - launching solution-architect agent..."
  echo "SUBAGENT: solution-architect"
  exit 0
  ;;
"technical-support")
  echo "🔍 Claude detected investigation task - launching technical-support agent..."
  echo "SUBAGENT: technical-support"
  exit 0
  ;;
"dba")
  echo "🗃️ Claude detected database task - launching dba agent..."
  echo "SUBAGENT: dba"
  exit 0
  ;;
"principal-engineer")
  echo "🎯 Claude detected strategic planning task - launching principal-engineer agent..."
  echo "SUBAGENT: principal-engineer"
  exit 0
  ;;
"sre")
  echo "⚡ Claude detected SRE task - launching sre agent..."
  echo "SUBAGENT: sre"
  exit 0
  ;;
*)
  # Continue with main agent for general tasks or if selection failed
  exit 1
  ;;
esac
