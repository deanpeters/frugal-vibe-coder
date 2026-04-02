# Frugal Vibe Coder

~~~text
╔════════════════════════════════════════════════════════════════════════════╗
║                                                                            ║
║   ███████╗██████╗ ██╗   ██╗ ██████╗  █████╗ ██╗         ██╗   ██╗██╗██████╗ ║
║   ██╔════╝██╔══██╗██║   ██║██╔════╝ ██╔══██╗██║         ██║   ██║██║██╔══██╗║
║   █████╗  ██████╔╝██║   ██║██║  ███╗███████║██║         ██║   ██║██║██████╔╝║
║   ██╔══╝  ██╔══██╗██║   ██║██║   ██║██╔══██║██║         ╚██╗ ██╔╝██║██╔═══╝ ║
║   ██║     ██║  ██║╚██████╔╝╚██████╔╝██║  ██║███████╗     ╚████╔╝ ██║██║     ║
║   ╚═╝     ╚═╝  ╚═╝ ╚═════╝  ╚═════╝ ╚═╝  ╚═╝╚══════╝      ╚═══╝  ╚═╝╚═╝     ║
║                                                                            ║
║   A learning platform for AI-assisted product building                     ║
║   Dyad • OpenCode • VS Code • Ollama • Local-first • Budget-aware          ║
║                                                                            ║
╚════════════════════════════════════════════════════════════════════════════╝
~~~

**Learn how to build with AI — clearly, confidently, and without a surprise bill.**

This is a learning platform first. Budget-consciousness is a core design constraint, not the whole point. The goal is to help you understand modern AI tooling, make good decisions about when and how to use it, and build real things without needing expensive APIs, premium subscriptions, or high-end hardware.

If you've looked at modern AI tooling and thought:

- "This looks powerful, but I can't afford to experiment freely"
- "Everything assumes I'll burn API credits just to get started"
- "I want to actually understand what's happening, not just copy prompts"

This repo is built for you.

---

## What You'll Learn

This is not a list of tools. It is a set of skills:

- what a package manager is and why it changes how you install software
- how to create and use a free GitHub repository
- what Ollama is and what is actually running on your machine
- how to choose between no-code, CLI, and IDE workflows
- when a local model is enough, and when a paid one is worth it
- how to build small, real apps without cloud dependency
- how to think like a product manager while building

---

## Three Learning Surfaces

You don't start with tools. You start with a problem and a set of constraints.

~~~text
Problem → Choose a surface → Choose a model → Build → Learn → Iterate
~~~

| Surface | Tools | Best for |
|--------|-------|---------|
| No-code | Dyad | First success, low friction, visual thinkers |
| CLI | OpenCode | Transparency, control, understanding what's happening |
| IDE | VS Code | Code inspection, real iteration, long-term skills |

These surfaces are independent. You can start with any one of them and move between them without losing your footing. Each connects back to the same foundational concepts.

---

## Platforms Supported

- macOS
- Windows
- Linux — Debian, Ubuntu, Mint

Hardware target: consumer laptop, 8–16 GB RAM, no GPU required.

---

## Models

**Default:** `qwen3:8b` via Ollama, used across all three surfaces.

This audience is primarily PMs and designers who ask thinking and product questions, not just code questions. A general-use model handles that better than a coding-specialized one. It runs locally on ordinary hardware and costs nothing per query.

**Optional upgrade:** `qwen2.5-coder:7b` — worth considering once you're doing real code iteration and understand why a coding-specialized model might help.

**Paid models:** supported as an optional layer. Default to the cheapest available:
- Anthropic: `claude-haiku-4-5`
- OpenAI: `gpt-4o-mini`

API keys live in your shell environment (`~/.zshrc` on Mac/Linux, Windows Environment Variables). They never go in a file in this repo.

---

## Configuration

Model choices and tool behavior are controlled by a single config file: `frugal-vibe.conf`. It is plain text, fully commented, and designed to be readable and editable without coding experience.

API keys are never stored in this file or anywhere in the repo. If you switch to a paid provider and your key is not set in your environment, the setup will stop and tell you exactly where to add it — then offer to fall back to Ollama.

---

## What's in /docs

~~~text
/docs
  /concepts/     What is a package manager? What is Ollama? What is a git repo?
  /setup/        Step-by-step installation guides per tool and platform
  /surfaces/     How to use Dyad, OpenCode, and VS Code
  /reference/    Config locations, tool map, and your personal install log
~~~

Each concept doc explains one idea in plain language — what it is, why it matters, and one link if you want to go deeper. Setup guides check what you already have before doing anything, explain every step, and tell you what you now have when they're done.

`docs/reference/my-setup.md` is a local-only file written by the install scripts. It records everything installed on your machine — versions, config locations, and which surface each tool supports. It is never committed to git.

---

## Install Scripts

### Start here

**macOS / Linux:**
```bash
./scripts/setup.sh
```

**Windows** (PowerShell, run as Administrator):
```powershell
.\scripts\setup.ps1
```

Both scripts walk you through the full setup in order — package manager, Ollama, then whichever learning surfaces you choose. Nothing is installed without your confirmation.

### Install tools individually

```bash
./scripts/install-ollama.sh      # Ollama + default model
./scripts/install-dyad.sh        # Dyad — no-code surface
./scripts/install-opencode.sh    # OpenCode — CLI surface
./scripts/install-vscode.sh      # VS Code + Continue — IDE surface
```

Each script checks what you already have, explains every step, and records the result in `docs/reference/my-setup.md`.

Scripts detect your package manager (Homebrew, apt, Chocolatey) and use it when available. Nothing is overwritten without asking.

---

## Cost Model

| Layer | Default | Optional |
|------|---------|---------|
| Models | Local via Ollama | Paid APIs (Anthropic, OpenAI) |
| Tools | Free / open-source | Premium |
| Workflow | Local-first | Hybrid |

Paid tools are optional, situational, and never required to get started. The workflow for using them:

1. Build locally
2. Hit a real limitation
3. Diagnose the limitation
4. Use a paid model once, if it genuinely helps
5. Return to local

That builds judgment, not dependency.

---

## For Educators

This repo supports workshops, bootcamps, self-paced cohorts, and mixed-skill classrooms.

Core principle: minimize setup friction, maximize learning signal.

- student-friendly install scripts with conservative defaults
- multiple entry points for different comfort levels
- concept docs that explain the why, not just the how
- PM-friendly language throughout

---

## What's Coming

The current three surfaces (no-code, CLI, IDE) are the foundation. Future surfaces under consideration:

- **Visual agent-flow builders** — n8n (self-hosted), Flowise
- **Autonomous agent platforms** — OpenClaw, OpenHands
- **Coding agent frameworks** — SWE-agent

None of these are available yet. They will be introduced only when they can be done in a way that fits the learning platform principles of this repo.

---

## Contributing

Before contributing, read `AGENTS.md` for the full operating philosophy and non-negotiable rules. The short version:

- Does this increase cost or complexity for learners?
- Does this assume access or experience many people don't have?
- Is there a simpler, more local-first alternative?
- Does this teach judgment, not just procedure?

See `CLAUDE.md` for technical standards, the configuration architecture, and the `/docs` structure.
