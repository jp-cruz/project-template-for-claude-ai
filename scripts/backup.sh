#!/bin/bash

set -euo pipefail  # Exit on error, undefined vars, pipe failures

# Local backup script for project

BACKUP_DIR="$HOME/backups"
PROJECT_NAME=$(basename "$PWD")
TIMESTAMP=$(date +%Y%m%d-%H%M%S)

# Validate project name (only allow alphanumeric, dash, underscore, dot)
if [[ ! "$PROJECT_NAME" =~ ^[a-zA-Z0-9._-]+$ ]]; then
    echo "❌ Invalid project name: $PROJECT_NAME"
    echo "Project name can only contain letters, numbers, dots, dashes, and underscores"
    exit 1
fi

BACKUP_FILE="$BACKUP_DIR/${PROJECT_NAME}-backup-$TIMESTAMP.tar.gz"

echo "📦 Creating local backup for: $PROJECT_NAME"

# Create backup directory if it doesn't exist
mkdir -p "$BACKUP_DIR"

# Create backup excluding common directories
tar -czf "$BACKUP_FILE" \
    --exclude='.git' \
    --exclude='node_modules' \
    --exclude='dist' \
    --exclude='build' \
    --exclude='.cache' \
    .

if [ $? -eq 0 ]; then
    echo "✅ Backup created: $BACKUP_FILE"
    
    # Keep only last 10 backups - use find for safer file handling
    echo "🧹 Cleaning up old backups (keeping last 10)..."
    find "$BACKUP_DIR" -name "${PROJECT_NAME}-backup-*.tar.gz" -type f -print0 | \
        sort -z | \
        head -z -n -10 | \
        xargs -0 -r rm -v
    echo "✅ Cleanup complete"
else
    echo "❌ Backup failed"
    exit 1
fi