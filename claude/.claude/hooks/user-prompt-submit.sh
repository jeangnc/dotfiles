#!/bin/bash
# User prompt submit hook for Great Question development
# Analyzes user intent and automatically launches appropriate subagents

USER_PROMPT="$1"

# Debug and error investigation scenarios
if [[ "$USER_PROMPT" =~ (fix|debug|broken|failing|not working|error|exception|investigate|why.*fail|what.*wrong) ]]; then
    echo "🔧 Debugging task detected - auto-launching debugger agent..."
    echo "SUBAGENT: debugger"
    exit 0
fi

# Code review scenarios
if [[ "$USER_PROMPT" =~ (review|check.*code|analyze.*code|look.*at.*code|code.*quality|security.*review) ]]; then
    echo "👀 Code review request detected - auto-launching code-reviewer agent..."
    echo "SUBAGENT: code-reviewer"
    exit 0
fi

# Feature development with testing
if [[ "$USER_PROMPT" =~ (implement|create.*feature|add.*functionality|build.*feature|new.*endpoint) ]]; then
    echo "🛠️ Feature development detected - auto-launching developer agent for BDD approach..."
    echo "SUBAGENT: developer"
    exit 0
fi

# Data analysis and SQL queries
if [[ "$USER_PROMPT" =~ (sql|query|database|data.*analy|bigquery|count.*records|find.*data|export.*data) ]]; then
    echo "📊 Data analysis task detected - auto-launching data-scientist agent..."
    echo "SUBAGENT: data-scientist"
    exit 0
fi

# System design and architecture
if [[ "$USER_PROMPT" =~ (architect|design.*system|scale|performance|infrastructure|how.*should.*structure) ]]; then
    echo "🏗️ System architecture task detected - auto-launching solution-architect agent..."
    echo "SUBAGENT: solution-architect"
    exit 0
fi

# Complex technical investigation
if [[ "$USER_PROMPT" =~ (investigate|analyze.*issue|deep.*dive|root.*cause|technical.*analysis|why.*happen) ]]; then
    echo "🔍 Technical investigation detected - auto-launching technical-support agent..."
    echo "SUBAGENT: technical-support"
    exit 0
fi

# Database administration tasks
if [[ "$USER_PROMPT" =~ (migration|schema|index|optimize.*query|database.*performance|db:) ]]; then
    echo "🗃️ Database administration task detected - auto-launching dba agent..."
    echo "SUBAGENT: dba"
    exit 0
fi

# Let normal processing continue for other requests
exit 1