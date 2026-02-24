# shizai-pro

## Project Overview
Rails 8.1 + Tailwind CSS 4 project, targeting AWS Amplify deployment.

## Tech Stack
- Ruby 3.3.10 (rbenv)
- Rails 8.1.2
- Tailwind CSS 4 (via tailwindcss-rails)
- SQLite3
- Importmap for JS
- Hotwire (Turbo + Stimulus)

## Figma Integration
- Figma MCP is configured for design-to-code workflows
- Source design: https://www.figma.com/design/tnxuN8LS2uMJEw2lYnvx69/shizai-pro

## Development
- `bin/dev` to start development server (Puma + Tailwind watcher)
- `bin/rails tailwindcss:build` to build Tailwind CSS

## Deployment
- AWS Amplify (see amplify.yml)
