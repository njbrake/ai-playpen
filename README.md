# AI Playpen

A Docker-based development sandbox that bundles multiple AI coding assistants into a single isolated environment. Built on Docker's official Claude Code sandbox template with additional AI tools pre-installed.

## Included Tools

| Tool | Provider | Description |
|------|----------|-------------|
| [Claude Code](https://github.com/anthropics/claude-code) | Anthropic | CLI for Claude AI |
| [OpenCode](https://github.com/opencode-ai/opencode) | OpenCode | Open-source code assistant |
| [Codex](https://github.com/openai/codex) | OpenAI | OpenAI's Codex CLI |
| [Mistral Vibe](https://github.com/mistralai/mistral-vibe) | Mistral AI | Mistral-powered coding tool |

## Prerequisites

- Docker Desktop 4.50 or later
- Docker Compose
- API keys for the tools you want to use:
  - `ANTHROPIC_API_KEY` for Claude Code
  - `OPENAI_API_KEY` for Codex
  - `MISTRAL_API_KEY` for Mistral Vibe

## Quick Start

1. Set up your environment variables:

```bash
export ANTHROPIC_API_KEY=sk-ant-...
export OPENAI_API_KEY=sk-...
export MISTRAL_API_KEY=...
```

2. Build and start the sandbox:

```bash
docker compose up -d
docker compose exec sandbox bash
```

3. Inside the container, run any of the installed tools:

```bash
claude          # Start Claude Code
opencode        # Start OpenCode
codex           # Start Codex
vibe            # Start Mistral Vibe
```

## How It Works

When you run the sandbox:

- Your project directory is mounted at the same path inside the container
- API credentials are stored in a persistent Docker volume (`ai-playpen-credentials`) mounted at `/mnt/claude-data`
- The container runs as the `agent` user with sudo privileges
- All AI tools are pre-installed and ready to use

The container continues running in the background. Running `docker compose exec sandbox bash` again reuses the existing container, allowing you to maintain state (installed packages, temporary files, stored credentials) across sessions.

## Configuration

### Persistent Credentials

API credentials and tool configurations are automatically stored in the `ai-playpen-credentials` Docker volume, persisting across container restarts and rebuilds.

### Git Configuration

On first use, configure Git inside the container:

```bash
git config --global user.name "Your Name"
git config --global user.email "your.email@example.com"
```

### Environment Variables

Pass API keys via environment variables. You can either:

1. Export them in your shell before running docker compose
2. Create a `.env` file in the project root:

```bash
ANTHROPIC_API_KEY=sk-ant-...
OPENAI_API_KEY=sk-...
MISTRAL_API_KEY=...
```

## Managing the Sandbox

Stop the sandbox:
```bash
docker compose down
```

Rebuild after updating the Dockerfile:
```bash
docker compose up -d --build
```

Remove the sandbox and its volume:
```bash
docker compose down -v
```
