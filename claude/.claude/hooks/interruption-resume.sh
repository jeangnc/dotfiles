#!/bin/bash
# Interruption resume hook - intelligent context continuation

USER_PROMPT="$1"
CLAUDE_DIR="$HOME/.dotfiles/claude/.claude"
STATE_FILE="$CLAUDE_DIR/.agent_state"

# Check if user explicitly wants to change context
if [[ "$USER_PROMPT" =~ (new agent|different agent|switch agent|stop agent|start over|fresh start) ]]; then
  rm -f "$STATE_FILE"
  exit 1
fi

# Check if we should continue with the same agent
if [[ -f "$STATE_FILE" ]]; then
  LAST_AGENT=$(cat "$STATE_FILE")
  if [[ -n "$LAST_AGENT" && -f "$CLAUDE_DIR/agents/$LAST_AGENT.md" ]]; then
    # Use Claude to determine if we should continue with the same agent
    local escaped_prompt=$(echo "$USER_PROMPT" | sed 's/"/\\"/g')
    local continuation_prompt="Should I continue with the previous $LAST_AGENT agent for this follow-up request?

    PREVIOUS AGENT: $LAST_AGENT
    NEW REQUEST: \"$escaped_prompt\"

    Respond with 'yes' if this request is a natural continuation of the previous task, or 'no' if it's a completely different task that would be better handled by a different agent or the main assistant."

    local should_continue=$(echo "$continuation_prompt" | claude --max-tokens 10 --temperature 0.1 2>/dev/null | tr -d '\n' | tr -d ' ')

    if [[ "$should_continue" == "yes" ]]; then
      echo "🔄 Continuing with $LAST_AGENT agent..."
      echo "SUBAGENT: $LAST_AGENT"
      exit 0
    else
      # Clear state and let normal agent selection happen
      rm -f "$STATE_FILE"
    fi
  fi
fi

exit 1

