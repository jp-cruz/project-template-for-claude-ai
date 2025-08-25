#!/bin/bash

set -euo pipefail

# Project Template for Claude.ai Quality Audit Script
# Validates template against industry best practices

echo "🔍 Running Project Template for Claude.ai Quality Audit..."

SCORE=0
TOTAL=0
WARNINGS=()

# Function to check file existence and award points
check_file() {
    local file=$1
    local description=$2
    local points=${3:-1}
    
    TOTAL=$((TOTAL + points))
    
    if [ -f "$file" ]; then
        echo "✅ $description"
        SCORE=$((SCORE + points))
    else
        echo "❌ $description (Missing: $file)"
        WARNINGS+=("Missing: $file")
    fi
}

# Function to check directory existence
check_dir() {
    local dir=$1
    local description=$2
    local points=${3:-1}
    
    TOTAL=$((TOTAL + points))
    
    if [ -d "$dir" ]; then
        echo "✅ $description"
        SCORE=$((SCORE + points))
    else
        echo "❌ $description (Missing: $dir)"
        WARNINGS+=("Missing directory: $dir")
    fi
}

# Function to check package.json content
check_package_json() {
    local field=$1
    local description=$2
    local points=${3:-1}
    
    TOTAL=$((TOTAL + points))
    
    if [ -f "package.json" ] && jq -e ".$field" package.json > /dev/null 2>&1; then
        echo "✅ $description"
        SCORE=$((SCORE + points))
    else
        echo "❌ $description"
        WARNINGS+=("package.json missing field: $field")
    fi
}

echo ""
echo "📋 BASIC TEMPLATE STRUCTURE"
echo "=========================="
check_file "README.md" "Project documentation"
check_file "package.json" "Node.js project configuration"
check_file "LICENSE" "Open source license"
check_file "CONTRIBUTING.md" "Contribution guidelines"
check_file "CHANGELOG.md" "Version history"
check_file ".gitignore" "Git ignore patterns"

echo ""
echo "🏗️ PROJECT ARCHITECTURE"
echo "======================="
check_dir "src" "Source code directory"
check_dir "tests" "Test directory structure"
check_dir "__tests__" "Alternative test directory"
check_dir "docs" "Documentation directory"
check_file "tsconfig.json" "TypeScript configuration" 2

echo ""
echo "🔧 CODE QUALITY TOOLS"
echo "==================="
check_file ".eslintrc.js" "ESLint configuration" 2
check_file ".prettierrc" "Prettier configuration"
check_file "jest.config.js" "Jest testing configuration" 2

echo ""
echo "🔒 SECURITY PRACTICES"
echo "==================="
check_file "docs/SECURITY.md" "Security documentation" 2
check_file ".env.example" "Environment variable template"

# Check if pre-commit script has secret detection
if [ -f "scripts/pre-commit.sh" ] && grep -q "SECRET_PATTERNS" "scripts/pre-commit.sh"; then
    echo "✅ Pre-commit secret detection implemented"
    SCORE=$((SCORE + 2))
else
    echo "❌ Pre-commit secret detection missing"
    WARNINGS+=("Pre-commit secret detection not implemented")
fi
TOTAL=$((TOTAL + 2))

echo ""
echo "🐳 CONTAINERIZATION"
echo "=================="
check_file "Dockerfile" "Docker configuration" 2
check_file "docker-compose.yml" "Docker Compose configuration"
check_file ".dockerignore" "Docker ignore patterns"

echo ""
echo "🚀 CI/CD & AUTOMATION"
echo "===================="
check_dir ".github/workflows" "GitHub Actions workflows" 2
check_file ".github/workflows/ci.yml" "Continuous Integration"
check_file ".github/workflows/auto-backup.yml" "Automated backups"
check_dir ".github/ISSUE_TEMPLATE" "GitHub issue templates"
check_file ".github/PULL_REQUEST_TEMPLATE.md" "Pull request template"

echo ""
echo "📦 PACKAGE.JSON VALIDATION"
echo "=========================="
check_package_json "engines" "Node.js version requirements"
check_package_json "scripts.test" "Test script"
check_package_json "scripts.lint" "Lint script"
check_package_json "scripts.build" "Build script"
check_package_json "devDependencies" "Development dependencies"

echo ""
echo "🧪 TESTING SETUP"
echo "==============="
if [ -f "__tests__/example.test.ts" ] && grep -q "describe" "__tests__/example.test.ts"; then
    echo "✅ Example tests with proper structure"
    SCORE=$((SCORE + 1))
else
    echo "❌ Example tests missing or malformed"
    WARNINGS+=("Example tests not properly structured")
fi
TOTAL=$((TOTAL + 1))

if [ -f "tests/setup.ts" ]; then
    echo "✅ Test setup configuration"
    SCORE=$((SCORE + 1))
else
    echo "❌ Test setup configuration missing"
    WARNINGS+=("Test setup configuration missing")
fi
TOTAL=$((TOTAL + 1))

echo ""
echo "📊 AUDIT RESULTS"
echo "==============="
PERCENTAGE=$((SCORE * 100 / TOTAL))

echo "Score: $SCORE/$TOTAL ($PERCENTAGE%)"

if [ $PERCENTAGE -ge 90 ]; then
    echo "🏆 EXCELLENT - Industry leading template!"
    GRADE="A+"
elif [ $PERCENTAGE -ge 80 ]; then
    echo "🥇 VERY GOOD - Above industry standard"
    GRADE="A"
elif [ $PERCENTAGE -ge 70 ]; then
    echo "🥈 GOOD - Meets industry standards"
    GRADE="B+"
elif [ $PERCENTAGE -ge 60 ]; then
    echo "🥉 ADEQUATE - Below industry standard"
    GRADE="B"
else
    echo "❌ NEEDS IMPROVEMENT - Missing critical components"
    GRADE="C"
fi

echo "Grade: $GRADE"

if [ ${#WARNINGS[@]} -gt 0 ]; then
    echo ""
    echo "⚠️ IMPROVEMENT RECOMMENDATIONS:"
    for warning in "${WARNINGS[@]}"; do
        echo "  - $warning"
    done
fi

echo ""
echo "✅ Audit completed!"

# Return appropriate exit code
if [ $PERCENTAGE -ge 80 ]; then
    exit 0
else
    exit 1
fi