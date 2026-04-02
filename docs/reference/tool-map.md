# Tool Map

A quick reference for every tool in this repo — what it is, what surface it supports, and where to learn more.

---

## Fastest setup path

If you want the repo to guide you instead of installing each tool by hand:

- macOS / Linux: `./scripts/setup.sh`
- Windows: `.\scripts\setup.ps1`

Those scripts walk you through package manager setup, Ollama, and whichever learning surfaces you choose.

---

## Core tools

| Tool | What it is | Surface | Cost | Platform |
|------|-----------|---------|------|---------|
| [Ollama](https://ollama.com) | Runs AI models locally on your machine | All | Free | macOS, Windows, Linux |
| [Dyad](https://dyad.sh) | No-code visual app builder | No-code | Free | macOS, Windows, Linux |
| [OpenCode](https://opencode.ai) | Terminal-based AI coding agent | CLI | Free | macOS, Windows, Linux |
| [VS Code](https://code.visualstudio.com) | Code editor | IDE | Free | macOS, Windows, Linux |
| [Continue](https://continue.dev) | AI assistant extension for VS Code | IDE | Free | macOS, Windows, Linux |

---

## Package managers

| Tool | Platform | What it manages |
|------|---------|----------------|
| [Homebrew](https://brew.sh) | macOS | Software installation and updates |
| [Chocolatey](https://chocolatey.org) | Windows | Software installation and updates |
| apt | Debian / Ubuntu / Mint | Software installation and updates (pre-installed) |

---

## Models

| Model | Provider | Size | Best for | Cost |
|-------|---------|------|---------|------|
| `qwen3:8b` | Ollama (local) | ~5 GB | General use — questions, reasoning, product thinking | Free |
| `qwen2.5-coder:7b` | Ollama (local) | ~4.5 GB | Code-focused work — optional upgrade | Free |
| `claude-haiku-4-5` | Anthropic (paid) | Cloud | Fast, cheap paid option — requires API key | Pay per use |
| `claude-sonnet-4-6` | Anthropic (paid) | Cloud | More capable paid option — requires API key | Pay per use |
| `gpt-4o-mini` | OpenAI (paid) | Cloud | Fast, cheap paid option — requires API key | Pay per use |
| `gpt-4o` | OpenAI (paid) | Cloud | More capable paid option — requires API key | Pay per use |

Default: `qwen3:8b`. Switch to a paid model by updating `MODEL_PROVIDER` in `frugal-vibe.conf` and setting the appropriate API key in your shell environment.

---

## Learning surfaces

| Surface | Primary tool | When to use it | Setup guide |
|--------|-------------|---------------|------------|
| No-code | Dyad | First success, rapid prototyping, low friction | [setup/dyad.md](../setup/dyad.md) |
| CLI | OpenCode | Transparency, control, understanding the process | [setup/opencode.md](../setup/opencode.md) |
| IDE | VS Code + Continue | Code inspection, targeted edits, transferable skills | [setup/vscode.md](../setup/vscode.md) |

---

## Future tools (not yet available)

These are on the roadmap but not part of the current repo. Do not attempt to set them up using this repo's guides — they don't exist yet.

| Tool | Category | What it will support |
|------|---------|---------------------|
| [n8n](https://n8n.io) (self-hosted) | Visual agent-flow builder | Future fourth surface |
| [Flowise](https://flowiseai.com) | Visual agent-flow builder | Future fourth surface |
| [OpenClaw](https://openclaw.ai) | Autonomous agent platform | Future fifth surface |
| [OpenHands](https://github.com/All-Hands-AI/OpenHands) | Autonomous agent platform | Future fifth surface |
| SWE-agent | Coding agent framework | Advanced / optional |

---

## Config and documentation quick links

| What you need | Where to go |
|--------------|------------|
| Where a tool stores its settings | [config-locations.md](config-locations.md) |
| What's installed on your machine | [my-setup.md](my-setup.md) (local only) |
| How the model/provider config works | [concepts/what-is-a-config-file.md](../concepts/what-is-a-config-file.md) |
| How API keys work and where they live | [concepts/what-is-an-api-key.md](../concepts/what-is-an-api-key.md) |
