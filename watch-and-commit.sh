#!/bin/bash

# Real-time file watcher that auto-commits changes
# Requires: brew install fswatch

echo "🔍 Starting file watcher for auto-commits..."
echo "📁 Watching: $(pwd)"
echo "🛑 Press Ctrl+C to stop"

# Function to commit changes
commit_changes() {
    if ! git diff --quiet || ! git diff --cached --quiet; then
        timestamp=$(date '+%Y-%m-%d %H:%M:%S')
        git add -A
        git commit -m "🤖 Auto-commit: $timestamp"
        echo "✅ Auto-committed at $timestamp"
        echo "🔄 To revert: git reset --hard HEAD~1"
    fi
}

# Watch for file changes (excluding .git directory)
fswatch -o . --exclude='.git' | while read f; do
    sleep 2  # Debounce rapid changes
    commit_changes
done
