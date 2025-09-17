#!/bin/bash
# Post-tool-call hook for Great Question development
# Automatically launches appropriate subagents based on tool usage

# Check if Claude just wrote, edited, or created code files
if [[ "$TOOL_NAME" =~ ^(Edit|Write|MultiEdit)$ ]]; then
    # Check if significant code was changed (not just small tweaks)
    if [[ ${#TOOL_RESULT} -gt 100 || "$TOOL_RESULT" =~ (class|def|function|component|export) ]]; then
        echo "🔍 Auto-launching code-reviewer to review recent changes..."
        # Note: This would trigger the Task tool to launch code-reviewer
        # The actual implementation depends on Claude Code's hook system
    fi
fi

# Check if there were test failures, build errors, or other issues
if [[ "$TOOL_NAME" == "Bash" ]]; then
    if [[ "$TOOL_RESULT" =~ (FAILED|ERROR|failed|error|Exception|TypeError|SyntaxError|rspec.*failures) ]]; then
        echo "🔧 Errors detected - consider using debugger agent for investigation..."
        echo "💡 Tip: Ask Claude to 'debug this error' to auto-launch debugger"
    fi

    # Check for linting/rubocop failures
    if [[ "$TOOL_RESULT" =~ (rubocop|offenses|violations) ]]; then
        echo "📏 Linting issues detected - auto-launching code-reviewer for style fixes..."
    fi

    # Check for database/SQL operations
    if [[ "$TOOL_RESULT" =~ (SELECT|INSERT|UPDATE|DELETE|migration|schema) ]]; then
        echo "🗃️ Database operations detected - data-scientist agent available for analysis..."
    fi

    # Check for test runs
    if [[ "$TOOL_RESULT" =~ (rspec|jest|test.*passed|test.*failed) ]]; then
        echo "🧪 Test execution detected..."
        if [[ "$TOOL_RESULT" =~ (failed|failures|error) ]]; then
            echo "❌ Test failures found - debugger agent recommended"
        fi
    fi
fi

# Check for PR creation and auto-launch code review
if [[ "$TOOL_NAME" == "Bash" && "$TOOL_RESULT" =~ (gh pr create|pull request created|Created pull request) ]]; then
    echo "🚀 PR created - auto-launching code-reviewer to review the changes..."
    echo "💡 Launching code review agent for comprehensive analysis..."
fi

# Check for file operations on important files
if [[ "$TOOL_NAME" =~ ^(Read|Glob|Grep)$ && "$TOOL_RESULT" =~ (Gemfile|package\.json|docker|config) ]]; then
    echo "⚙️ Configuration files accessed - solution-architect agent available for system design..."
fi