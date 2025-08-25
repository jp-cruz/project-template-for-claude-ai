#!/bin/bash

set -euo pipefail

# Supply Chain Security Audit Script
# Proactive verification beyond trusting third-party services

echo "🔒 Running Supply Chain Security Audit..."
echo "========================================="

# Colors for output
RED='\033[0;31m'
YELLOW='\033[1;33m'
GREEN='\033[0;32m'
NC='\033[0m' # No Color

CRITICAL_ISSUES=0
WARNINGS=0

# Function to report issues
report_critical() {
    echo -e "${RED}❌ CRITICAL: $1${NC}"
    CRITICAL_ISSUES=$((CRITICAL_ISSUES + 1))
}

report_warning() {
    echo -e "${YELLOW}⚠️  WARNING: $1${NC}"
    WARNINGS=$((WARNINGS + 1))
}

report_ok() {
    echo -e "${GREEN}✅ $1${NC}"
}

echo ""
echo "🔍 1. NPM PACKAGE VERIFICATION"
echo "=============================="

# Check for package-lock.json (prevents floating versions)
if [ -f "package-lock.json" ]; then
    report_ok "Package lock file exists - versions are pinned"
else
    report_critical "No package-lock.json - versions can float (supply chain risk)"
fi

# Check for suspicious packages or typosquatting
if [ -f "package.json" ]; then
    echo "Scanning for potentially suspicious packages..."
    
    # Common typosquatted packages
    SUSPICIOUS_PATTERNS=(
        "eslnt"
        "recat"
        "lodas"
        "expres"
        "noed"
        "ndoe"
        "npm-"
        "node-"
    )
    
    for pattern in "${SUSPICIOUS_PATTERNS[@]}"; do
        if grep -q "$pattern" package.json; then
            report_warning "Potential typosquatting detected: $pattern"
        fi
    done
    
    report_ok "Basic typosquatting check completed"
fi

echo ""
echo "🔍 2. GITHUB ACTIONS SECURITY"
echo "============================="

# Check if GitHub Actions pin to commit hashes instead of tags
if [ -d ".github/workflows" ]; then
    echo "Checking GitHub Actions pinning..."
    
    # Look for unpinned actions (using @v1, @v2 instead of commit hashes)
    if find .github/workflows -name "*.yml" -exec grep -l "uses:.*@v[0-9]" {} \; | head -1 > /dev/null 2>&1; then
        report_warning "GitHub Actions using version tags instead of commit hashes"
        echo "  Recommendation: Pin to commit hashes (e.g., uses: actions/checkout@8f4b7c11f4c4c4b4...)"
    else
        report_ok "GitHub Actions are properly pinned"
    fi
    
    # Check for third-party actions without verification
    echo "Scanning for third-party GitHub Actions..."
    if find .github/workflows -name "*.yml" -exec grep -E "uses: [^(actions/|github/)]" {} \; > /dev/null 2>&1; then
        report_warning "Third-party GitHub Actions detected - verify their security"
        find .github/workflows -name "*.yml" -exec grep -E "uses: [^(actions/|github/)]" {} \; | sed 's/^/    /'
    else
        report_ok "Only official GitHub Actions detected"
    fi
else
    report_warning "No GitHub Actions workflows found"
fi

echo ""
echo "🔍 3. DEPENDENCY INTEGRITY CHECKS"
echo "================================="

# Check for integrity hashes in package-lock.json
if [ -f "package-lock.json" ]; then
    if grep -q '"integrity"' package-lock.json; then
        report_ok "Package integrity hashes present"
    else
        report_critical "No integrity hashes in package-lock.json - regenerate lockfile"
    fi
    
    # Check lockfile version
    LOCKFILE_VERSION=$(jq -r '.lockfileVersion // 1' package-lock.json 2>/dev/null || echo "1")
    if [ "$LOCKFILE_VERSION" -ge "2" ]; then
        report_ok "Using modern lockfile format (v$LOCKFILE_VERSION)"
    else
        report_warning "Using old lockfile format - consider upgrading npm"
    fi
fi

echo ""
echo "🔍 4. SOURCE CODE VERIFICATION"
echo "=============================="

# Check for suspicious code patterns that might indicate compromise
echo "Scanning for suspicious code patterns..."

SUSPICIOUS_CODE_PATTERNS=(
    "eval\("
    "Function\("
    "spawn\("
    "exec\("
    "http\.request"
    "fetch\(.*['\"]http"
    "atob\("
    "btoa\("
    "\\x[0-9a-fA-F]{2}"
    "fromCharCode"
)

for pattern in "${SUSPICIOUS_CODE_PATTERNS[@]}"; do
    if find . -name "*.js" -o -name "*.ts" | grep -v node_modules | xargs grep -l "$pattern" 2>/dev/null; then
        report_warning "Suspicious code pattern detected: $pattern"
        echo "    Files:"
        find . -name "*.js" -o -name "*.ts" | grep -v node_modules | xargs grep -l "$pattern" 2>/dev/null | sed 's/^/      /'
    fi
done

report_ok "Source code pattern scan completed"

echo ""
echo "🔍 5. ENVIRONMENT SECURITY"
echo "=========================="

# Check for exposed secrets in config files
echo "Checking for potential secret exposure..."

# Check if .env files are in .gitignore
if [ -f ".gitignore" ]; then
    if grep -q "\.env" .gitignore; then
        report_ok "Environment files properly ignored by git"
    else
        report_critical ".env files not in .gitignore - secrets could be exposed"
    fi
else
    report_critical "No .gitignore file found"
fi

# Check for hardcoded URLs that might be compromised
if find . -name "*.js" -o -name "*.ts" -o -name "*.json" | grep -v node_modules | xargs grep -i "http.*://" 2>/dev/null | grep -v localhost > /dev/null; then
    report_warning "Hardcoded URLs detected - verify they're legitimate"
    find . -name "*.js" -o -name "*.ts" -o -name "*.json" | grep -v node_modules | xargs grep -i "http.*://" 2>/dev/null | grep -v localhost | head -5 | sed 's/^/    /'
fi

echo ""
echo "🔍 6. BUILD PROCESS SECURITY"
echo "============================"

# Check for secure build practices
if [ -f "package.json" ]; then
    # Check for postinstall scripts (common attack vector)
    if grep -q '"postinstall"' package.json; then
        report_warning "postinstall script detected - review for malicious code"
        grep -A 1 -B 1 '"postinstall"' package.json | sed 's/^/    /'
    else
        report_ok "No postinstall scripts found"
    fi
    
    # Check for preinstall scripts
    if grep -q '"preinstall"' package.json; then
        report_warning "preinstall script detected - review for malicious code"
        grep -A 1 -B 1 '"preinstall"' package.json | sed 's/^/    /'
    else
        report_ok "No preinstall scripts found"
    fi
fi

echo ""
echo "🔍 7. NETWORK SECURITY"
echo "======================"

# Check for insecure HTTP URLs in package.json
if [ -f "package.json" ]; then
    if grep -q '"http://' package.json; then
        report_critical "Insecure HTTP URLs found in package.json"
        grep '"http://' package.json | sed 's/^/    /'
    else
        report_ok "No insecure HTTP URLs in package.json"
    fi
fi

echo ""
echo "📊 AUDIT SUMMARY"
echo "================"
echo -e "Critical Issues: ${RED}$CRITICAL_ISSUES${NC}"
echo -e "Warnings: ${YELLOW}$WARNINGS${NC}"

if [ $CRITICAL_ISSUES -gt 0 ]; then
    echo -e "${RED}❌ CRITICAL ISSUES FOUND - Address immediately${NC}"
    exit 1
elif [ $WARNINGS -gt 0 ]; then
    echo -e "${YELLOW}⚠️  WARNINGS FOUND - Review and address${NC}"
    exit 0
else
    echo -e "${GREEN}✅ SUPPLY CHAIN SECURITY LOOKS GOOD${NC}"
    exit 0
fi