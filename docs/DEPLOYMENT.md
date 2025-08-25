# Deployment Guide

## Prerequisites

- Node.js LTS version
- npm or yarn package manager
- Environment variables configured

## Build Process

1. Install production dependencies
   ```bash
   npm ci --production
   ```

2. Build the application
   ```bash
   npm run build
   ```

3. Test the build locally
   ```bash
   npm run preview
   ```

## Environment Variables

Create `.env.production` with:

```
# Database
DATABASE_URL=

# API Keys
API_KEY=

# Other config
NODE_ENV=production
```

## Deployment Options

### Option 1: Static Hosting
- Build: `npm run build`
- Deploy `dist/` folder to your host

### Option 2: Node.js Server
- Build: `npm run build`
- Start: `npm start`

### Option 3: Docker
- Use included `Dockerfile`
- Build: `docker build -t app .`
- Run: `docker run -p 3000:3000 app`

## CI/CD

GitHub Actions automatically:
- Runs tests on pull requests
- Creates backups on main branch pushes
- Can be extended for auto-deployment