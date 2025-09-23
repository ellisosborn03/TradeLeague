#!/bin/bash

# Simple auto-commit for Cursor/Claude usage
# Run this before and after Claude sessions

case "$1" in
    "start")
        echo "🚀 Starting Claude session..."
        ./auto-commit.sh "Before Claude session - $(date '+%H:%M')"
        echo "💡 Run './cursor-auto-commit.sh end' when done"
        ;;
    "end")
        echo "🏁 Ending Claude session..."
        ./auto-commit.sh "After Claude session - $(date '+%H:%M')"
        echo "✅ Claude changes committed!"
        ;;
    "save")
        echo "💾 Saving progress..."
        ./auto-commit.sh "Claude progress checkpoint - $(date '+%H:%M')"
        ;;
    *)
        echo "Usage:"
        echo "  ./cursor-auto-commit.sh start    # Before using Claude"
        echo "  ./cursor-auto-commit.sh save     # Save progress during work"
        echo "  ./cursor-auto-commit.sh end      # After Claude session"
        ;;
esac

