# Development Guide

## Getting Started

1. Clone the repository
2. Install dependencies: `npm install`
3. Start development server: `npm run dev`

## Development Workflow

1. Create feature branch from `main`
2. Make changes and test locally
3. Run linting: `npm run lint`
4. Run type checking: `npm run typecheck`
5. Commit changes with descriptive message
6. Push and create pull request

## Project Structure

```
/
├── src/           # Source code
├── docs/          # Documentation
├── scripts/       # Automation scripts
├── .github/       # GitHub workflows
├── .vscode/       # Editor settings
└── .devcontainer/ # Container config
```

## Code Standards

- Use TypeScript for type safety
- Follow ESLint rules
- Format with Prettier
- Write meaningful commit messages
- Add tests for new features

## Available Scripts

- `npm run dev` - Start development server
- `npm run build` - Build for production
- `npm run test` - Run tests
- `npm run lint` - Check code style
- `npm run typecheck` - Check TypeScript