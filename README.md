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

## Working on Different Projects

By default, the sandbox mounts the `ai-playpen` directory as your workspace. To work on a different project:

**Option 1: Set environment variables before starting**

```bash
cd ~/scm/personal/ai-playpen
export WORKSPACE_DIR=/path/to/your/project
export WORKSPACE_MOUNT=/workspace  # Optional: customize the container path
docker compose up -d
docker compose exec sandbox bash
```

**Option 2: Inline with docker compose**

```bash
cd ~/scm/personal/ai-playpen
WORKSPACE_DIR=/path/to/your/project docker compose up -d
docker compose exec sandbox bash
```

**Option 3: Add to your .env file**

```bash
# In ai-playpen/.env
WORKSPACE_DIR=/path/to/your/project
WORKSPACE_MOUNT=/workspace
```

Then run `docker compose up -d` as usual. The specified directory will be mounted at `/workspace` (or your custom mount path) inside the container, and that will be your working directory.

### Running Multiple Containers Simultaneously

You can run multiple sandbox containers for different projects at the same time. All containers will share the same `ai-playpen-credentials` volume, so your API keys and tool configurations are consistent across all instances.

To run multiple containers, set a unique `CONTAINER_NAME` for each:

```bash
# Terminal 1: Start container for project A
cd ~/scm/personal/ai-playpen
WORKSPACE_DIR=~/projects/project-a CONTAINER_NAME=sandbox-project-a docker compose up -d
docker exec -it sandbox-project-a bash

# Terminal 2: Start container for project B
cd ~/scm/personal/ai-playpen
WORKSPACE_DIR=~/projects/project-b CONTAINER_NAME=sandbox-project-b docker compose up -d
docker exec -it sandbox-project-b bash

# Terminal 3: Start container for project C
cd ~/scm/personal/ai-playpen
WORKSPACE_DIR=~/projects/project-c CONTAINER_NAME=sandbox-project-c docker compose up -d
docker exec -it sandbox-project-c bash
```

Each container:
- Runs independently with its own workspace
- Shares the same `ai-playpen-credentials` volume (API keys, tool configs)
- Has a unique name for easy management

To stop a specific container:
```bash
CONTAINER_NAME=sandbox-project-a docker compose down
```

To list all running containers:
```bash
docker ps --filter "name=sandbox-"
```

## How It Works

When you run the sandbox:

- Your workspace directory is mounted at `/workspace` inside the container (configurable via `WORKSPACE_MOUNT`)
- API credentials are stored in a persistent Docker volume (`ai-playpen-credentials`) mounted at `/mnt/claude-data`
- The container runs as the `agent` user with sudo privileges
- All AI tools are pre-installed and ready to use

The container continues running in the background. Running `docker compose exec sandbox bash` again reuses the existing container, allowing you to maintain state (installed packages, temporary files, stored credentials) across sessions.

## Configuration

### OpenCode Configuration

OpenCode requires a configuration file. Create an `opencode.json` file in the project root (this file is gitignored):

- If you already have OpenCode installed, you can copy your existing config from `~/.config/opencode/opencode.json`
- For configuration options and schema, see: https://opencode.ai/config.json
- The file will be mounted into the container at `~/.config/opencode/opencode.json` at runtime

### Persistent Credentials

API credentials and tool configurations are automatically stored in the `ai-playpen-credentials` Docker volume, persisting across container restarts and rebuilds.

### Git Configuration

On first use, configure Git inside the container:

```bash
git config --global user.name "Your Name"
git config --global user.email "your.email@example.com"
```

### Environment Variables

Pass API keys and workspace configuration via environment variables. You can either:

1. Export them in your shell before running docker compose
2. Create a `.env` file in the project root:

```bash
# API Keys
ANTHROPIC_API_KEY=sk-ant-...
OPENAI_API_KEY=sk-...
MISTRAL_API_KEY=...

# Workspace Configuration (optional)
WORKSPACE_DIR=/path/to/your/project    # Defaults to current directory (.)
WORKSPACE_MOUNT=/workspace             # Defaults to /workspace
CONTAINER_NAME=ai-playpen-sandbox      # Defaults to ai-playpen-sandbox
```

## Managing the Sandbox

Stop the default sandbox:
```bash
docker compose down
```

Stop a specific container (when running multiple):
```bash
CONTAINER_NAME=sandbox-project-a docker compose down
```

Rebuild after updating the Dockerfile:
```bash
docker compose up -d --build
```

Remove the default sandbox and its volume:
```bash
docker compose down -v
```

**Note:** The `ai-playpen-credentials` volume is shared across all containers. Removing it with `-v` will delete stored credentials for all sandbox instances. To remove just the container without affecting the shared volume, use `docker compose down` without the `-v` flag.

---

## Disclaimer

This repository was generated using Claude Code (Opus 4.5). Some components may not be fully functional or tested. Use at your own risk.
