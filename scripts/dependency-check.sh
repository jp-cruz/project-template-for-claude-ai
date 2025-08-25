#!/bin/bash

set -euo pipefail

# Dependency Integrity Verification Script
# Enhanced security checks for npm dependencies

echo "🔍 Dependency Integrity & Security Check"
echo "========================================"

RED='\033[0;31m'
YELLOW='\033[1;33m'
GREEN='\033[0;32m'
BLUE='\033[0;34m'
NC='\033[0m'

ERRORS=0
WARNINGS=0

report_error() {
    echo -e "${RED}❌ ERROR: $1${NC}"
    ERRORS=$((ERRORS + 1))
}

report_warning() {
    echo -e "${YELLOW}⚠️  WARNING: $1${NC}"
    WARNINGS=$((WARNINGS + 1))
}

report_info() {
    echo -e "${BLUE}ℹ️  INFO: $1${NC}"
}

report_ok() {
    echo -e "${GREEN}✅ $1${NC}"
}

# Check if npm is available
if ! command -v npm &> /dev/null; then
    report_error "npm is not installed"
    exit 1
fi

echo ""
echo "🔍 1. PACKAGE INTEGRITY VERIFICATION"
echo "===================================="

# Verify package-lock.json exists and is recent
if [ ! -f "package-lock.json" ]; then
    report_error "package-lock.json not found - run 'npm install' first"
    exit 1
fi

# Check if package-lock.json is newer than package.json
if [ "package.json" -nt "package-lock.json" ]; then
    report_warning "package.json is newer than package-lock.json - run 'npm install'"
fi

# Verify integrity hashes exist
if ! grep -q '"integrity":' package-lock.json; then
    report_error "No integrity hashes in package-lock.json - regenerate lockfile"
else
    INTEGRITY_COUNT=$(grep -c '"integrity":' package-lock.json)
    report_ok "Found $INTEGRITY_COUNT integrity hashes in lockfile"
fi

echo ""
echo "🔍 2. VULNERABILITY SCANNING"
echo "============================"

# Run npm audit
echo "Running npm audit..."
if npm audit --audit-level=moderate; then
    report_ok "No moderate or higher vulnerabilities found"
else
    AUDIT_EXIT_CODE=$?
    if [ $AUDIT_EXIT_CODE -eq 1 ]; then
        report_warning "Some vulnerabilities found - review npm audit output"
    else
        report_error "Critical vulnerabilities found - run 'npm audit fix'"
    fi
fi

echo ""
echo "🔍 3. DEPENDENCY ANALYSIS"
echo "========================="

# Check for unused dependencies
if command -v npx &> /dev/null; then
    echo "Checking for unused dependencies..."
    if npx depcheck --quiet 2>/dev/null; then
        report_ok "No unused dependencies detected"
    else
        report_warning "Unused dependencies detected - run 'npx depcheck' for details"
    fi
else
    report_info "npx not available - skipping unused dependency check"
fi

# Check for outdated packages
echo "Checking for outdated packages..."
OUTDATED_OUTPUT=$(npm outdated --json 2>/dev/null || echo "{}")
if [ "$OUTDATED_OUTPUT" = "{}" ]; then
    report_ok "All packages are up to date"
else
    OUTDATED_COUNT=$(echo "$OUTDATED_OUTPUT" | jq 'length' 2>/dev/null || echo "0")
    if [ "$OUTDATED_COUNT" -gt "0" ]; then
        report_info "$OUTDATED_COUNT packages have updates available"
        echo "Run 'npm outdated' for details"
    fi
fi

echo ""
echo "🔍 4. MALWARE SCANNING"
echo "======================"

# Basic malware patterns in dependencies
echo "Scanning for suspicious patterns in dependencies..."

# Check for packages with postinstall scripts
if [ -f "package-lock.json" ]; then
    POSTINSTALL_PACKAGES=$(jq -r '
        .packages | 
        to_entries | 
        map(select(.value.scripts.postinstall != null)) | 
        map(.key) | 
        .[]
    ' package-lock.json 2>/dev/null || echo "")
    
    if [ -n "$POSTINSTALL_PACKAGES" ]; then
        report_warning "Packages with postinstall scripts detected:"
        echo "$POSTINSTALL_PACKAGES" | while read -r pkg; do
            echo "    - $pkg"
        done
        echo "  Review these packages carefully for malicious code"
    else
        report_ok "No postinstall scripts in dependencies"
    fi
fi

echo ""
echo "🔍 5. REGISTRY VERIFICATION"
echo "==========================="

# Check npm registry configuration
REGISTRY=$(npm config get registry)
if [ "$REGISTRY" = "https://registry.npmjs.org/" ]; then
    report_ok "Using official npm registry"
elif [[ "$REGISTRY" == https://* ]]; then
    report_info "Using custom secure registry: $REGISTRY"
else
    report_warning "Using non-HTTPS registry: $REGISTRY"
fi

# Check for authentication tokens in .npmrc
if [ -f ".npmrc" ]; then
    if grep -q "_authToken" .npmrc; then
        if grep -q "\${" .npmrc; then
            report_ok "Auth token uses environment variable"
        else
            report_error "Hardcoded auth token in .npmrc - use environment variables"
        fi
    fi
fi

echo ""
echo "🔍 6. LICENSE COMPLIANCE"
echo "========================"

# Check for packages with problematic licenses
echo "Scanning package licenses..."
if command -v npx &> /dev/null; then
    # Common problematic licenses
    PROBLEMATIC_LICENSES=("GPL-3.0" "AGPL" "SSPL" "Commons Clause")
    
    # Get license info (this would require license-checker package)
    report_info "License checking requires additional tooling"
    echo "  Consider running: npx license-checker --onlyAllow 'MIT;Apache-2.0;BSD-2-Clause;BSD-3-Clause;ISC'"
fi

echo ""
echo "🔍 7. SUPPLY CHAIN VERIFICATION"
echo "==============================="

# Check package metadata for red flags
if [ -f "package-lock.json" ]; then
    echo "Analyzing package metadata..."
    
    # Count total dependencies
    TOTAL_DEPS=$(jq '.packages | length' package-lock.json 2>/dev/null || echo "0")
    report_info "Total packages in lockfile: $TOTAL_DEPS"
    
    # Check for packages with suspicious characteristics
    echo "Checking for potential supply chain risks..."
    
    # This is a simplified check - in practice you'd want more sophisticated analysis
    if [ "$TOTAL_DEPS" -gt "500" ]; then
        report_warning "Large number of dependencies ($TOTAL_DEPS) - increases attack surface"
    elif [ "$TOTAL_DEPS" -gt "200" ]; then
        report_info "Moderate number of dependencies ($TOTAL_DEPS)"
    else
        report_ok "Reasonable number of dependencies ($TOTAL_DEPS)"
    fi
fi

echo ""
echo "📊 DEPENDENCY CHECK SUMMARY"
echo "==========================="
echo -e "Errors: ${RED}$ERRORS${NC}"
echo -e "Warnings: ${YELLOW}$WARNINGS${NC}"

# Recommendations
echo ""
echo "🔧 SECURITY RECOMMENDATIONS"
echo "==========================="
echo "1. Run 'npm audit' regularly and fix vulnerabilities"
echo "2. Use 'npm ci' in production for deterministic installs"
echo "3. Pin package versions in package.json (avoid ^ and ~)"
echo "4. Review all postinstall scripts before adding dependencies"
echo "5. Consider using 'npm pack' to inspect packages before installing"
echo "6. Set up automated dependency monitoring with tools like:"
echo "   - Dependabot"
echo "   - Snyk"
echo "   - Socket.dev"
echo "   - FOSSA"

if [ $ERRORS -gt 0 ]; then
    echo -e "\n${RED}❌ CRITICAL ISSUES FOUND - Fix before proceeding${NC}"
    exit 1
elif [ $WARNINGS -gt 0 ]; then
    echo -e "\n${YELLOW}⚠️  WARNINGS FOUND - Review recommendations${NC}"
    exit 0
else
    echo -e "\n${GREEN}✅ DEPENDENCY SECURITY LOOKS GOOD${NC}"
    exit 0
fi