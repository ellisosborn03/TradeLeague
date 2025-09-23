#!/bin/bash

# Auto-commit Claude's changes in real-time
# Run this in background while using Claude

echo "🤖 Starting Claude change watcher..."
echo "📁 Watching: $(pwd)"
echo "🛑 Press Ctrl+C to stop"

# Last commit hash to track changes
LAST_COMMIT=$(git rev-parse HEAD)

# Function to commit Claude's changes
commit_claude_changes() {
    if ! git diff --quiet || ! git diff --cached --quiet; then
        timestamp=$(date '+%H:%M:%S')
        
        # Get list of changed files
        changed_files=$(git diff --name-only | head -3 | tr '\n' ' ')
        
        git add -A
        git commit -m "🤖 Claude: $timestamp - Modified: $changed_files"
        
        echo "✅ Auto-committed Claude changes at $timestamp"
        echo "📝 Files: $changed_files"
        echo "🔄 To revert: git reset --hard HEAD~1"
        echo ""
    fi
}

# Watch for file changes every 3 seconds
while true; do
    sleep 3
    commit_claude_changes
done

