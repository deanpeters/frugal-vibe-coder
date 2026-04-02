# Frugal Vibe Coder

~~~text
╔════════════════════════════════════════════════════════════════════════════╗
║                                                                            ║
████████╗██╗  ██╗███████╗    ███████╗██████╗ ██╗   ██╗ ██████╗  █████╗ ██╗   ║  
╚══██╔══╝██║  ██║██╔════╝    ██╔════╝██╔══██╗██║   ██║██╔════╝ ██╔══██╗██║   ║  
   ██║   ███████║█████╗      █████╗  ██████╔╝██║   ██║██║  ███╗███████║██║   ║  
║  ██║   ██╔══██║██╔══╝      ██╔══╝  ██╔══██╗██║   ██║██║   ██║██╔══██║██║   ║  
║  ██║   ██║  ██║███████╗    ██║     ██║  ██║╚██████╔╝╚██████╔╝██║  ██║███████╗
║  ╚═╝   ╚═╝  ╚═╝╚══════╝    ╚═╝     ╚═╝  ╚═╝ ╚═════╝  ╚═════╝ ╚═╝  ╚═╝╚══════╝
║                                                                            ║  
██╗   ██╗██╗██████╗ ███████╗     ██████╗ ██████╗ ██████╗ ███████╗██████╗     ║  
██║   ██║██║██╔══██╗██╔════╝    ██╔════╝██╔═══██╗██╔══██╗██╔════╝██╔══██╗    ║  
██║   ██║██║██████╔╝█████╗      ██║     ██║   ██║██║  ██║█████╗  ██████╔╝    ║  
╚██╗ ██╔╝██║██╔══██╗██╔══╝      ██║     ██║   ██║██║  ██║██╔══╝  ██╔══██╗    ║  
 ╚████╔╝ ██║██████╔╝███████╗    ╚██████╗╚██████╔╝██████╔╝███████╗██║  ██║    ║  
║ ╚═══╝  ╚═╝╚═════╝ ╚══════╝     ╚═════╝ ╚═════╝ ╚═════╝ ╚══════╝╚═╝  ╚═╝    ║  
║                                                                            ║
║   A learning platform for AI-assisted product building • Version 0.05.00   ║
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

## Early Testers Wanted

This project is still in an early stage, and I am actively looking for people to help test it on real machines and real learner setups.

The most helpful testing right now is:

- running the current setup scripts on macOS, Windows, and Linux
- checking whether the supported tools install and connect cleanly
- noting where the docs feel clear, confusing, incomplete, or too technical
- pointing out what would make this more useful as a learning tool

I am especially interested in feedback on what else this repo should provide in order to be genuinely helpful for learners, including:

- better documentation
- more examples
- clearer step-by-step instruction
- troubleshooting help
- starter exercises or sample projects
- other forms of learner support and guidance

If you test this repo and something is confusing, fragile, or missing, that feedback is valuable. The goal is to make this work well for more people on more platforms, not just on one machine with one level of technical confidence.

---

## Quick Start

If you're on a Mac and you want the simplest path, do this:

1. Get the repo onto your machine.

If you do **not** use git yet:
- On GitHub, click **Code** → **Download ZIP**
- Unzip the file
- Move the folder somewhere easy to find, like your Desktop or Documents

If you **do** use git:

```bash
git clone https://github.com/deanpeters/frugal-vibe-coder.git
cd frugal-vibe-coder
```

2. Open Terminal.
3. Move into the project folder.

If you downloaded the ZIP and the folder is on your Desktop, the folder name may be `frugal-vibe-coder-main`:

```bash
cd ~/Desktop/frugal-vibe-coder-main
```

4. Run the guided setup:

```bash
./scripts/setup.sh
```

That script walks you through the setup in plain language, checks what is already installed, and asks before making changes.

**Best first path for most beginners on Mac:**
- install Ollama
- choose Dyad as your first learning surface
- come back later for OpenCode or VS Code when you want more visibility or control

If you'd rather read first and run later:
- [docs/setup/README.md](docs/setup/README.md)
- [docs/concepts/what-is-ollama.md](docs/concepts/what-is-ollama.md)
- [docs/surfaces/README.md](docs/surfaces/README.md)

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

Both scripts walk you through the full setup in order — package manager, Ollama, then whichever learning surfaces you choose. Nothing is installed without your confirmation. If a script needs to replace an existing tool config, it asks first and creates a backup before changing anything.

### Install tools individually

```bash
./scripts/install-ollama.sh      # Ollama + default model
./scripts/install-dyad.sh        # Dyad — no-code surface
./scripts/install-opencode.sh    # OpenCode — CLI surface
./scripts/install-vscode.sh      # VS Code + Continue — IDE surface
```

Each script checks what you already have, explains every step, verifies manual installs before moving on, and records the result in `docs/reference/my-setup.md`.

Scripts detect your package manager (Homebrew, apt, Chocolatey) and use it when available. Existing configs are left alone unless you choose to replace them, and backups are created first.

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

The current three surfaces (no-code, CLI, IDE) are the foundation. The full expansion plan is in `ROADMAP.md`. In brief:

| Phase | Focus |
|-------|-------|
| 2 | Sample projects — the same app built three ways |
| 3 | Instructor resources — workshops, setup checklists, troubleshooting |
| 4 | Paid model onboarding — when, how, and how to stay in control of costs |
| 5 | Prompts and templates — PM-oriented, copy-paste ready |
| 6 | Future surfaces — n8n, Flowise, OpenClaw, OpenHands, SWE-agent |

The repo is also considering broader support over time for other tools that fit the same access-first philosophy:

- no-code / low-code: `bolt.diy`
- CLI: `Goose`
- IDE / editor: `VSCodium`
- future visual agent-flow builders: `n8n`, `Flowise`
- future autonomous agent platforms: `OpenClaw`, `OpenHands`
- future coding agent frameworks: `SWE-agent`

These are not all active or documented yet. They will be introduced only when they can be done in a way that fits the learning platform principles of this repo: low-cost, local-first where practical, beginner-respectful, and realistic on ordinary hardware.

---

## Contributing

Before contributing, read `AGENTS.md` for the full operating philosophy and non-negotiable rules. The short version:

- Does this increase cost or complexity for learners?
- Does this assume access or experience many people don't have?
- Is there a simpler, more local-first alternative?
- Does this teach judgment, not just procedure?

See `CLAUDE.md` for technical standards, the configuration architecture, and the `/docs` structure. See `ROADMAP.md` for the full expansion plan.
