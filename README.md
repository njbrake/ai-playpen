# Code Sandbox

A Docker-based development sandbox that bundles multiple AI coding assistants into a single isolated environment.

## Included Tools

| Tool | Provider | Description |
|------|----------|-------------|
| [Claude Code](https://github.com/anthropics/claude-code) | Anthropic | CLI for Claude AI |
| [OpenCode](https://github.com/opencode-ai/opencode) | OpenCode | Open-source code assistant |
| [Codex](https://github.com/openai/codex) | OpenAI | OpenAI's Codex CLI |
| [Mistral Vibe](https://github.com/mistralai/mistral-vibe) | Mistral AI | Mistral-powered coding tool |

## Prerequisites

- Docker and Docker Compose
- API keys for the tools you want to use:
  - `ANTHROPIC_API_KEY` for Claude Code
  - `OPENAI_API_KEY` for Codex
  - `MISTRAL_API_KEY` for Mistral Vibe

## Quick Start

1. Clone the repository and set up your environment:

```bash
cp .env.example .env
# Edit .env with your API keys
```

2. Build and run the sandbox:

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

## Configuration

The sandbox mounts configuration directories from your host machine, so settings persist between container restarts:

- `~/.claude` → Claude Code config
- `~/.config/opencode` → OpenCode config
- `~/.codex` → Codex config
- `~/.vibe` → Mistral Vibe config

Place your project files in the `./workspace` directory to work on them inside the container.

## Environment Variables

Set these in your `.env` file or export them in your shell:

```bash
export ANTHROPIC_API_KEY=sk-ant-...
export OPENAI_API_KEY=sk-...
export MISTRAL_API_KEY=...
```

The container will automatically pick up these environment variables.
