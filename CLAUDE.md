# Claude Code Configuration

## Project Information
- **Project Name**: [Replace with project name]
- **Description**: [Replace with project description]
- **Primary Language**: [Replace with main language]
- **Framework**: [Replace with framework if applicable]

## Development Commands
```bash
# Install dependencies
npm install

# Start development server
npm run dev

# Run tests
npm test

# Build project
npm run build

# Lint code
npm run lint

# Type check
npm run typecheck

# Security checks (before committing)
./scripts/pre-commit.sh
```

## Project Structure
[Describe your project structure here]

## Key Files
- Main entry point: [path]
- Configuration: [path]
- Tests: [path]
- Security guide: `docs/SECURITY.md`

## Security Reminders for Claude
🔒 **CRITICAL**: Never commit secrets, API keys, or credentials
- Use environment variables (`.env` files)
- Use GitHub Secrets for CI/CD
- Run `./scripts/pre-commit.sh` before commits
- Check `docs/SECURITY.md` for security setup

## Notes for Claude
- Use existing conventions in this codebase
- Run lint and typecheck before marking tasks complete
- **Always run security checks** with `./scripts/pre-commit.sh`
- Follow security best practices (see `docs/SECURITY.md`)
- Always check package.json for available libraries
- Enable GitHub secret scanning in repository settings
- Never ignore security warnings without review

## Security Checklist for New Projects
- [ ] Enable GitHub secret scanning and push protection
- [ ] Review and follow `docs/SECURITY.md` setup guide
- [ ] Configure `.env.example` template
- [ ] Set up repository secrets for CI/CD
- [ ] Run security pre-commit checks