# Contributing to Project Template for Claude.ai

Thank you for your interest in contributing! This document provides guidelines for contributing to this project.

## 🤝 How to Contribute

### Reporting Issues
- Use the [issue templates](.github/ISSUE_TEMPLATE/) to report bugs or request features
- Search existing issues before creating new ones
- Provide clear, detailed descriptions with reproduction steps

### Submitting Changes

1. **Fork the repository**
   ```bash
   git clone https://github.com/[USERNAME]/project-template-for-claude-ai.git
   cd project-template-for-claude-ai
   ```

2. **Create a feature branch**
   ```bash
   git checkout -b feature/your-feature-name
   ```

3. **Make your changes**
   - Follow the existing code style
   - Add tests for new features
   - Update documentation as needed

4. **Test your changes**
   ```bash
   npm test
   npm run lint
   npm run typecheck
   ./scripts/pre-commit.sh
   ```

5. **Commit your changes**
   ```bash
   git add .
   git commit -m "feat: add your feature description"
   ```

6. **Push and create a pull request**
   ```bash
   git push origin feature/your-feature-name
   ```

## 📋 Development Setup

### Prerequisites
- Node.js 18+ 
- npm or yarn
- Git

### Installation
```bash
# Clone the repository
git clone https://github.com/[USERNAME]/project-template-for-claude-ai.git
cd project-template-for-claude-ai

# Install dependencies
npm install

# Run setup script
./scripts/setup.sh
```

### Running Tests
```bash
# Run all tests
npm test

# Run tests in watch mode
npm run test:watch

# Run tests with coverage
npm run test:coverage
```

### Code Quality
```bash
# Lint code
npm run lint

# Fix linting issues
npm run lint:fix

# Format code
npm run format

# Type check
npm run typecheck
```

## 📝 Code Guidelines

### Commit Messages
Follow [Conventional Commits](https://conventionalcommits.org/):

```
type(scope): description

feat: add new feature
fix: fix bug
docs: update documentation
style: formatting changes
refactor: code refactoring
test: add tests
chore: maintenance tasks
```

### Code Style
- Use TypeScript for type safety
- Follow ESLint and Prettier configurations
- Write meaningful variable and function names
- Add JSDoc comments for public APIs
- Keep functions small and focused

### Testing
- Write unit tests for new features
- Maintain test coverage above 70%
- Use descriptive test names
- Group related tests with `describe` blocks

## 🔒 Security

### Reporting Security Issues
- **DO NOT** create public issues for security vulnerabilities
- Use GitHub's [private security advisory](https://github.com/[USERNAME]/project-template-for-claude-ai/security/advisories/new)
- Include detailed reproduction steps and impact assessment

### Security Guidelines
- Never commit secrets or API keys
- Run security checks before committing
- Follow the security guide in `docs/SECURITY.md`

## 🎯 Pull Request Process

1. **Ensure your PR:**
   - Has a clear title and description
   - Links to related issues
   - Includes tests for new features
   - Passes all CI checks
   - Updates documentation if needed

2. **PR Review Process:**
   - Maintainers will review within 48 hours
   - Address feedback promptly
   - Ensure CI passes before requesting re-review

3. **Merging:**
   - PRs require at least one approval
   - All CI checks must pass
   - Squash and merge is preferred

## 🚀 Release Process

### Versioning
- Follow [Semantic Versioning](https://semver.org/)
- Use conventional commits for automated releases
- Update CHANGELOG.md for each release

### Release Checklist
- [ ] Update version in package.json
- [ ] Update CHANGELOG.md
- [ ] Create release notes
- [ ] Tag the release
- [ ] Publish to npm (if applicable)

## 🤔 Questions?

- Check existing [issues](https://github.com/[USERNAME]/project-template-for-claude-ai/issues)
- Start a [discussion](https://github.com/[USERNAME]/project-template-for-claude-ai/discussions)
- Review project documentation

## 🤖 AI Development Context

This project was created through human-AI collaboration using Claude (Anthropic). Contributors should be aware that:

- The original codebase was generated through AI assistance with human oversight
- Future contributions may involve AI tools - please disclose AI usage in pull requests
- We encourage responsible AI development practices and transparency

## 📜 License & Attribution

By contributing to this project, you agree that your contributions will be licensed under the MIT License. 

### Attribution Guidelines
- All contributors will be credited in the project documentation
- Significant contributions may be acknowledged in release notes
- The project maintains its MIT license for maximum community benefit

## 📜 Code of Conduct

This project follows the [Contributor Covenant Code of Conduct](https://contributor-covenant.org/). By participating, you agree to uphold this code.

### Our Standards

**Examples of behavior that contributes to a positive environment:**
- Using welcoming and inclusive language
- Being respectful of differing viewpoints
- Gracefully accepting constructive criticism
- Focusing on what is best for the community

**Examples of unacceptable behavior:**
- Harassment of any kind
- Trolling, insulting, or derogatory comments
- Publishing private information without consent
- Any conduct that could reasonably be considered inappropriate

---

Thank you for contributing! 🎉