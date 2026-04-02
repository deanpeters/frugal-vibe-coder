# my-setup.template.md

This file shows what `my-setup.md` can look like once the install scripts have run. The actual `my-setup.md` is local to your machine and never committed to git.

If you're looking for your personal install log, it's at `docs/reference/my-setup.md` in your local copy of this repo.

---

*Below is an example of what a populated `my-setup.md` can look like. The exact sections depend on which setup scripts you ran and which choices you made.*

---

# My Setup

*Generated and updated by frugal-vibe-coder install scripts. Last updated: [date]*

---

## Ollama

| Item | Value |
|------|-------|
| Version | 0.x.x |
| Installed via | Homebrew |
| Config location | `~/.ollama/` |
| Surfaces supported | No-code (Dyad), CLI (OpenCode), IDE (VS Code) |

## Dyad

| Item | Value |
|------|-------|
| Version | installed |
| Installed via | manual download |
| Config location | `~/Library/Application Support/Dyad/` |
| Surfaces supported | No-code |

## OpenCode

| Item | Value |
|------|-------|
| Version | x.x.x |
| Installed via | Homebrew |
| Config location | `~/.config/opencode/` |
| Surfaces supported | CLI |

## VS Code

| Item | Value |
|------|-------|
| Version | x.x.x |
| Installed via | Homebrew Cask |
| Config location | `~/Library/Application Support/Code/User/settings.json` |
| Surfaces supported | IDE |

## Continue (VS Code extension)

| Item | Value |
|------|-------|
| Extension ID | continue.continue |
| Config location | `~/.continue/config.json` |
| Provider | ollama |
| Model | qwen3:8b |

---

Sometimes a script run may keep your existing Continue config unchanged instead of replacing it. In that case, the section could look like this instead:

## Continue (VS Code extension)

| Item | Value |
|------|-------|
| Extension ID | continue.continue |
| Config location | `~/.continue/config.json` |
| Status | Existing config left unchanged |

---

Notes about how the current scripts behave:

- Existing configs are left alone unless you choose to replace them.
- If you choose replace, the scripts create a timestamped backup first.
- Rerunning setup updates the matching section instead of adding duplicate sections.
