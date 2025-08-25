#!/bin/bash

set -euo pipefail  # Exit on error, undefined vars, pipe failures

# Project Template for Claude.ai Setup Script

echo "🚀 Setting up Project Template for Claude.ai v0.1a..."

# Check if git is installed
if ! command -v git &> /dev/null; then
    echo "❌ Git is required but not installed"
    exit 1
fi

# Check if node is installed
if ! command -v node &> /dev/null; then
    echo "❌ Node.js is required but not installed"
    exit 1
fi

# Initialize git repository if not already initialized
if [ ! -d ".git" ]; then
    echo "📦 Initializing Git repository..."
    git init
    git add .
    git commit -m "Initial commit: Project Template for Claude.ai v0.1a"
fi

# Install dependencies
echo "📋 Installing dependencies..."
npm install

# Ask before installing Claude Code globally
if ! command -v claude &> /dev/null; then
    echo "🤖 Claude Code not found."
    read -p "Install Claude Code globally? (y/N): " -n 1 -r
    echo
    if [[ $REPLY =~ ^[Yy]$ ]]; then
        npm install -g @anthropic-ai/claude-code
    else
        echo "⚠️ Skipped Claude Code installation"
    fi
fi

# Create initial project structure
echo "📁 Creating project structure..."
mkdir -p src tests

# Safely set executable permissions only for known scripts
echo "🔧 Setting up script permissions..."
for script in "setup.sh" "backup.sh" "pre-commit.sh"; do
    if [ -f "scripts/$script" ]; then
        chmod +x "scripts/$script"
        echo "  ✓ Made scripts/$script executable"
    fi
done

echo "✅ Setup complete!"
echo ""
echo "Next steps:"
echo "1. Update CLAUDE.md with your project details"
echo "2. Customize package.json scripts"
echo "3. Start coding in the src/ directory"
echo "4. Run 'claude' to start Claude Code session"