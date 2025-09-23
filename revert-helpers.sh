#!/bin/bash

# Quick revert helper commands

echo "🔄 Git Revert Helper Commands:"
echo ""
echo "📋 Recent commits:"
git log --oneline -10
echo ""
echo "🔧 Quick commands:"
echo "  git reset --hard HEAD~1    # Go back 1 commit"
echo "  git reset --hard HEAD~3    # Go back 3 commits" 
echo "  git reset --hard <hash>    # Go to specific commit"
echo "  git reflog                 # See all recent actions"
echo ""
echo "💡 To revert to a specific commit:"
echo "  1. Copy the commit hash from above"
echo "  2. Run: git reset --hard <hash>"
echo ""
echo "⚠️  WARNING: --hard will delete uncommitted changes!"
echo "   Use --soft to keep changes staged"


