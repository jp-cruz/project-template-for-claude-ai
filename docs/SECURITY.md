# 🔒 Security Setup Guide

## Essential Security Configuration (2025 Best Practices)

### 🚨 Step 1: Enable GitHub Secret Scanning (REQUIRED)

**For every new repository using this template:**

1. Navigate to **Settings → Code security and analysis**
2. Enable these features:
   ```
   ✅ Secret scanning
   ✅ Push protection  
   ✅ Dependency review
   ✅ Private vulnerability reporting
   ```

**Why this matters:**
- Detects 750+ secret types automatically
- AI-powered detection with low false positives
- Push protection blocks commits containing secrets
- **New in 2025**: Enhanced detection patterns and custom org-level rules

### 🔐 Step 2: Secrets Management Best Practices

#### GitHub Secrets (for CI/CD)
```bash
# Repository Settings → Secrets and variables → Actions
# Add secrets like:
DEPLOYMENT_TOKEN=xxx
DATABASE_URL=xxx
API_KEY=xxx
```

#### Environment Files (for local development)
```bash
# Create .env files (already in .gitignore)
cp .env.example .env
# Edit .env with your local values
```

**⚠️ NEVER commit `.env` files**

### 🛡️ Step 3: Pre-commit Security Checks

Our `pre-commit.sh` script automatically checks for:
- Secrets and API keys
- TODO/FIXME comments
- Console.log statements
- Code quality issues

### 🔍 Step 4: Regular Security Maintenance

#### Monthly Tasks:
- [ ] Rotate secrets (especially long-lived tokens)
- [ ] Review secret scanning alerts
- [ ] Update dependencies with security patches
- [ ] Audit repository permissions

#### Quarterly Tasks:
- [ ] Security dependency audit: `npm audit`
- [ ] Review and update access permissions
- [ ] Check for unused secrets and clean up

### 🚨 Common Security Mistakes to Avoid

❌ **DON'T:**
- Commit `.env` files or config with secrets
- Use the same secret across multiple environments
- Ignore GitHub security alerts
- Store secrets in code comments or documentation

✅ **DO:**
- Use GitHub Secrets for CI/CD variables
- Rotate secrets regularly
- Use environment-specific secrets
- Enable all GitHub security features

### 🆘 If You Accidentally Commit a Secret

1. **Immediately revoke/rotate the secret**
2. **Remove from Git history:**
   ```bash
   git filter-branch --force --index-filter \
   'git rm --cached --ignore-unmatch path/to/file' \
   --prune-empty --tag-name-filter cat -- --all
   ```
3. **Force push** (if safe to do so)
4. **Update the secret everywhere it was used**

### 📊 Security Checklist for New Projects

- [ ] Enable GitHub secret scanning and push protection
- [ ] Configure repository secrets for CI/CD
- [ ] Add `.env.example` template
- [ ] Run `./scripts/pre-commit.sh` before commits
- [ ] Set up branch protection rules
- [ ] Enable vulnerability alerts
- [ ] Configure automated dependency updates

### 🔗 Additional Resources

- [GitHub Secret Scanning Docs](https://docs.github.com/en/code-security/secret-scanning)
- [GitHub Actions Security Best Practices](https://docs.github.com/en/actions/security-guides/security-hardening-for-github-actions)
- [OWASP Top 10 Security Risks](https://owasp.org/www-project-top-ten/)

---

**🎯 Security is a process, not a product.** Regular maintenance and staying updated with latest practices is key to keeping your projects secure.