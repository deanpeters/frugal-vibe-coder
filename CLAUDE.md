# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## What This Repo Is

**frugal-vibe-coder** is a learning platform for AI-assisted product building. Budget-consciousness is a core design constraint, not the whole point. The primary audience is PMs and designers with little to no coding experience. There is no build pipeline, test suite, or linter. The "product" is the docs, scripts, and learning materials.

## Scripts

### Entry points

```bash
./scripts/setup.sh       # Full guided setup — macOS and Linux
./scripts/setup.ps1      # Full guided setup — Windows (run in PowerShell as Administrator)
```

### Individual installers (macOS and Linux)

```bash
./scripts/install-ollama.sh      # Install Ollama and pull the default model
./scripts/install-dyad.sh        # Install Dyad (no-code surface)
./scripts/install-opencode.sh    # Install OpenCode (CLI surface)
./scripts/install-vscode.sh      # Install VS Code + Continue extension (IDE surface)
```

Each installer: checks current state → offers use/update/install → explains every step → writes to `docs/reference/my-setup.md`.

### Shared library (`scripts/lib/`)

| File | Responsibility |
|------|---------------|
| `ui.sh` | Colors, print helpers, yes/no prompts, numbered choices |
| `platform.sh` | OS detection (macos/debian), arch detection, platform guard |
| `packages.sh` | Detect brew/apt, `pkg_install`, `pkg_upgrade`, `apt_update_if_needed` |
| `check.sh` | `get_tool_version`, `is_installed`, `ollama_model_exists` |
| `config.sh` | Load `frugal-vibe.conf` + local overrides, `check_api_key` with clear error messages |
| `state.sh` | Init and write `docs/reference/my-setup.md`, `record_install` |

### Configuration

`frugal-vibe.conf` in the repo root controls `MODEL_PROVIDER`, `LOCAL_MODEL`, and `PAID_MODEL`. It is committed and contains no secrets. Personal overrides go in `frugal-vibe.conf.local` (gitignored).

The legacy `install-dyad-ollama-mac.sh` in the repo root predates this structure and remains for reference only. Use `scripts/setup.sh` instead.

## Architecture: Three Learning Surfaces

The project is organized around three independent, equal-priority learning paths:

| Surface | Tools | Purpose |
|--------|-------|---------|
| No-code / low-code | Dyad, bolt.diy | First success, low friction, non-engineers |
| CLI | OpenCode, Goose | Transparency, structured workflows, under-the-hood understanding |
| IDE | VS Code, VSCodium | Code inspection, durable skills, real iteration |

These surfaces have no hard dependencies on each other. A learner can enter via any path.

**Default model:** `qwen3:8b` via Ollama, used across all three surfaces. This audience is PMs and designers, not engineers — they ask thinking and product questions, not just code questions. A general-use model handles that better than a coding-specialized one. `qwen2.5-coder:7b` is an optional upgrade once a learner is doing real code iteration and understands why it might help. Hardware target: macOS, Windows, or Linux (Debian/Ubuntu/Mint), 8–16 GB RAM, no GPU.

## Configuration Architecture

The repo uses a single config file (`frugal-vibe.conf`) for model choices and tool behavior. API keys never appear in this file or anywhere else in the repo.

**`frugal-vibe.conf` controls:**
- `MODEL_PROVIDER` — `ollama` (default) | `anthropic` | `openai`
- `LOCAL_MODEL` — which Ollama model to use (default: `qwen3:8b`)
- `PAID_MODEL` — cheapest option first (default: `claude-haiku-4-5` / `gpt-4o-mini`)

**API keys live in the shell environment only:**
- Mac/Linux: `~/.zshrc` or `~/.bashrc` — `export ANTHROPIC_API_KEY=...`
- Windows: System > Environment Variables

**Hard rules for scripts and docs:**
- Never write API keys to any file in this repo
- Never instruct a learner to put keys in a config file, `.env` file, or script
- If `MODEL_PROVIDER` is set to a paid provider but the key is missing from the environment: stop, print a clear message explaining where to set it, and offer Ollama as a fallback
- `.gitignore` must cover `*.env`, `.env*`, and any pattern that could catch an accidentally created secrets file

Ollama is always the starting point. Paid model support is an optional layer a learner opts into deliberately.

## Authoritative Guidance

`AGENTS.md` is the operational backbone. Read it before making substantive changes. Key mandates:

1. **Cost-awareness is mandatory** — every recommendation must consider upfront cost, recurring cost, model size, and API burn risk. Never recommend paid tools as the default.
2. **Local-first by default** — prefer Ollama + open-source tools over cloud APIs.
3. **Beginner-safe defaults** — smaller models, fewer steps, lower failure chance.
4. **Clarity over cleverness** — plain language, explicit tradeoffs, comments in scripts.
5. **Product-first framing** — connect implementation choices to user problems and learner outcomes.
6. **No prestige bias** — don't privilege trendy or premium tools.
7. **Preserve dignity** — treat cost-conscious design as a serious design principle, not a workaround.
8. **Respect different entry points** — don't assume the right starting point is always terminal, no-code, or IDE.

## Content and Contribution Standards

When adding or revising content, apply this decision framework (in order):
1. Can the learner do this locally?
2. Can the learner do this for free?
3. Can the learner do this on ordinary hardware?
4. Does it support real learning, not just output generation?
5. Is the interface appropriate for the learner's current stage?

**Documentation must:** state purpose first, list prerequisites explicitly, distinguish required from optional steps, explain *why* a choice was made, and identify which learner profile a guide targets.

**Script standards:** use conservative model defaults (7B–8B), fail loudly with clear output, print next steps, minimize admin privileges, separate core installs from optional model pulls.

Scripts must also:
- Detect package managers (Homebrew on Mac, Chocolatey on Windows) and use them when available — they produce cleaner installs and easier updates
- Check whether each tool is already installed before doing anything; present three explicit choices: use what's there, update, or install fresh
- Never silently overwrite an existing installation

**Tone:** practical, respectful, direct, pedagogic. Avoid hype, startup theater, and "anyone can build anything instantly" language.

**Learner Interaction Pattern:** every guide, tutorial, and script must follow the seven-step pattern defined in `AGENTS.md`: problem first → what it is → what you're about to do → check/choose → each step explained → confirm and orient → go deeper. Never lead with a command.

## /docs Structure

```
/docs
  /concepts/     Foundational concept introductions (what is a package manager, what is Ollama, etc.)
  /setup/        Installation guides per tool and platform
  /surfaces/     Workflow guides for no-code (Dyad), CLI (OpenCode), and IDE (VS Code)
  /reference/    Config locations, tool map, and my-setup.md (gitignored, local only)
```

`docs/reference/my-setup.md` is written and updated by install scripts. It records what is installed, what version, where its config lives, and which surface it supports. It is never committed.

## Roadmap

The full expansion plan is in `ROADMAP.md`. Five phases in order:

1. **Sample projects** — 3–4 projects, each built across all three surfaces
2. **Instructor resources** — workshop guides, setup checklists, troubleshooting
3. **Paid model onboarding** — step-by-step key setup, when-to-pay framework, cost guidance
4. **Prompts and templates** — PM-oriented, task-organized, copy-paste ready
5. **Future surfaces** — n8n/Flowise → OpenClaw/OpenHands → SWE-agent (Docker introduced as a prerequisite when needed)

Nothing in a future phase should be started until the prior phase is stable and reviewed. Each phase in `ROADMAP.md` has explicit scope, parameters, and open decisions.

## Future Scope (Deferred)

Three additional surface categories are on the roadmap but not yet in active scope. Do not implement or document them as available until explicitly moved to active:

- **Visual agent-flow builders** — n8n (self-hosted), Flowise
- **Autonomous agent platforms** — OpenClaw, OpenHands
- **Coding agent frameworks** — SWE-agent

See `AGENTS.md` for full rationale and guidance on each. When any are introduced, they must follow the Learner Interaction Pattern and prefer local/self-hosted versions.

## What to Avoid

- Recommending paid APIs as the default path
- Defaulting to 30B+ models
- Assuming Docker comfort, deep CLI fluency, or professional developer backgrounds
- Treating terminal workflows as inherently superior to visual tools
- Introducing architectural complexity that doesn't serve learners
- Extension overload in IDE content
