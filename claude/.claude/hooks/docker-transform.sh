#!/bin/bash

# Claude Code PreToolUse hook to transform bin/ commands to run in Docker
# when docker-compose.yml or compose.yml is present in the project.

# Read JSON input from stdin
INPUT=$(cat)

# Extract working directory and command
WORKING_DIR=$(echo "$INPUT" | jq -r '.cwd // "."')
COMMAND=$(echo "$INPUT" | jq -r '.tool_input.command // ""')

# Check if docker-compose.yml exists in the working directory
if [[ -f "$WORKING_DIR/docker-compose.yml" ]] || [[ -f "$WORKING_DIR/compose.yml" ]]; then
  # Only transform bin/ commands that aren't already using docker compose
  if [[ "$COMMAND" == bin/* ]] && [[ "$COMMAND" != docker\ compose* ]]; then
    # Transform the command to run via docker compose exec web
    TRANSFORMED_COMMAND="docker compose exec web $COMMAND"

    # Use jq to build valid JSON with proper escaping
    jq -n \
      --arg cmd "$TRANSFORMED_COMMAND" \
      '{
        "hookSpecificOutput": {
          "hookEventName": "PreToolUse",
          "permissionDecision": "allow",
          "permissionDecisionReason": "Auto-transformed bin/ command to run in Docker container",
          "updatedInput": {
            "command": $cmd
          }
        }
      }'
    exit 0
  fi
fi

# No transformation needed - let the command proceed as-is
exit 0
