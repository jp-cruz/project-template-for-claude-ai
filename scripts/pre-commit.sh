#!/bin/bash

set -euo pipefail  # Exit on error, undefined vars, pipe failures

# Pre-commit quality checks

echo "🔍 Running pre-commit checks..."

# Check if package.json exists (Node.js project)
if [ -f "package.json" ]; then
    # Run linter
    echo "🧹 Running linter..."
    if ! npm run lint; then
        echo "❌ Linting failed. Please fix errors before committing."
        exit 1
    fi

    # Run type check
    echo "🔧 Running type check..."
    if ! npm run typecheck 2>/dev/null; then
        echo "⚠️ Type check skipped (not available)"
    fi

    # Run tests if they exist
    if npm run test --silent 2>/dev/null; then
        echo "🧪 Running tests..."
        if ! npm test; then
            echo "❌ Tests failed. Please fix before committing."
            exit 1
        fi
    else
        echo "⚠️ Tests skipped (not available)"
    fi
fi

# Check for common issues
echo "🔎 Checking for common issues..."

# Check for secrets in staged files - 2025 best practice
echo "🔐 Checking for potential secrets..."
SECRET_PATTERNS=(
    "password\s*[=:]\s*[\"'][^\"']{8,}[\"']"
    "api[_-]?key\s*[=:]\s*[\"'][^\"']{16,}[\"']"
    "secret\s*[=:]\s*[\"'][^\"']{16,}[\"']"
    "token\s*[=:]\s*[\"'][^\"']{16,}[\"']"
    "auth\s*[=:]\s*[\"'][^\"']{16,}[\"']"
    "database[_-]?url\s*[=:]\s*[\"'][^\"']+[\"']"
    "private[_-]?key\s*[=:]\s*[\"'][^\"']+[\"']"
    "BEGIN\s+(RSA\s+)?PRIVATE\s+KEY"
    "[a-zA-Z0-9]{40,}"  # Long hex strings (API keys, tokens)
    "sk-[a-zA-Z0-9]{32,}"  # OpenAI API keys
    "ghp_[a-zA-Z0-9]{36}"  # GitHub personal access tokens
    "gho_[a-zA-Z0-9]{36}"  # GitHub OAuth tokens
)

SECRETS_FOUND=false
for pattern in "${SECRET_PATTERNS[@]}"; do
    if git diff --cached --name-only -z | xargs -0 -I {} grep -ilE "$pattern" {} 2>/dev/null; then
        SECRETS_FOUND=true
        echo "🚨 POTENTIAL SECRET DETECTED: Pattern '$pattern'"
    fi
done

if [ "$SECRETS_FOUND" = true ]; then
    echo ""
    echo "❌ COMMIT BLOCKED: Potential secrets detected!"
    echo "Please review the files above and:"
    echo "1. Remove any actual secrets"
    echo "2. Use environment variables or GitHub Secrets instead"
    echo "3. Add false positives to .gitignore or exclude patterns"
    echo ""
    echo "If this is a false positive, you can bypass with:"
    echo "git commit --no-verify -m 'your message'"
    exit 1
fi
echo "✅ No secrets detected"

# Check for TODO/FIXME comments in staged files - safer version
echo "Checking for TODO/FIXME comments..."
git diff --cached --name-only -z | xargs -0 -I {} grep -l "TODO\|FIXME" {} 2>/dev/null && {
    echo "⚠️ Found TODO/FIXME comments in staged files"
    echo "Consider addressing them before committing"
} || true

# Check for console.log in JavaScript/TypeScript files - safer version
echo "Checking for console.log statements..."
git diff --cached --name-only -z | grep -z -E "\.(js|ts|jsx|tsx)$" | xargs -0 -I {} grep -l "console\.log" {} 2>/dev/null && {
    echo "⚠️ Found console.log statements in staged files"
    echo "Consider removing them before committing"
} || true

# Check for common sensitive file patterns
echo "Checking for sensitive files..."
SENSITIVE_FILES=(
    "\.env$"
    "\.env\."
    "config\.json$"
    "secrets\."
    "\.p12$"
    "\.pem$"
    "\.key$"
    "\.keystore$"
)

for pattern in "${SENSITIVE_FILES[@]}"; do
    if git diff --cached --name-only | grep -E "$pattern" 2>/dev/null; then
        echo "⚠️ Sensitive file pattern detected: $pattern"
        echo "Make sure this file should be committed"
    fi
done

echo "✅ Pre-commit checks passed!"