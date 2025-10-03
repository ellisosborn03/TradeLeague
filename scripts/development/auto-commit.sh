#!/bin/bash

# Auto-commit script for agent changes
# Usage: ./auto-commit.sh "message"

MESSAGE=${1:-"Agent auto-commit: $(date '+%Y-%m-%d %H:%M:%S')"}

echo "🤖 Auto-committing changes..."

# Add all changes
git add -A

# Check if there are changes to commit
if git diff --cached --quiet; then
    echo "✅ No changes to commit"
    exit 0
fi

# Commit with timestamp
git commit -m "$MESSAGE"

echo "✅ Committed: $MESSAGE"

# Show recent commits for reference
echo ""
echo "📝 Recent commits:"
git log --oneline -5
