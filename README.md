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

```bash
cd ~/scm/personal/ai-playpen
WORKSPACE_DIR=/path/to/your/project docker compose up -d
docker compose exec sandbox bash
```

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

## Configuration

### OpenCode Configuration

OpenCode requires a configuration file. Create an `opencode.json` file in the project root (this file is gitignored):

- If you already have OpenCode installed, you can copy your existing config from `~/.config/opencode/opencode.json`
- For configuration options and schema, see: https://opencode.ai/config.json
- The file will be mounted into the container at `~/.config/opencode/opencode.json` at runtime

### Persistent Credentials

API credentials and tool configurations are automatically stored in the `ai-playpen-credentials` Docker volume, persisting across container restarts and rebuilds.

### Environment Variables

Pass API keys and workspace configuration via environment variables. You can either:

1. Export them in your shell before running docker compose
2. Create a `.env` file in the project root:

```bash
# API Keys
ANTHROPIC_API_KEY=sk-ant-...
OPENAI_API_KEY=sk-...
MISTRAL_API_KEY=...

```

**Note:** The `ai-playpen-credentials` volume is shared across all containers. Removing it with `-v` will delete stored credentials for all sandbox instances. To remove just the container without affecting the shared volume, use `docker compose down` without the `-v` flag.

---

## Disclaimer

This repository was generated using Claude Code (Opus 4.5). Some components may not be fully functional or tested. Use at your own risk.
