# my-setup.template.md

This file shows what `my-setup.md` looks like once the install scripts have run. The actual `my-setup.md` is local to your machine and never committed to git.

If you're looking for your personal install log, it's at `docs/reference/my-setup.md` in your local copy of this repo.

---

---
*Below is an example of what a fully populated my-setup.md looks like.*

---

# My Setup

*Generated and updated by frugal-vibe-coder install scripts. Last updated: [date]*

---

## Package manager

| Tool | Version | Platform | Installed via |
|------|---------|---------|--------------|
| Homebrew | 4.x.x | macOS | Manual install |

---

## Ollama

| Item | Value |
|------|-------|
| Version | 0.x.x |
| Installed via | Homebrew |
| Config location | `~/.ollama/` |
| Models location | `~/.ollama/models/` |

### Downloaded models

| Model | Size | Purpose |
|-------|------|---------|
| qwen3:8b | ~5 GB | General use — default for all surfaces |

---

## Dyad

| Item | Value |
|------|-------|
| Version | x.x.x |
| Installed via | Homebrew Cask |
| App location | `/Applications/Dyad.app` |
| Config location | `~/Library/Application Support/Dyad/` |
| Surface | No-code |
| Model | qwen3:8b via Ollama |

---

## OpenCode

| Item | Value |
|------|-------|
| Version | x.x.x |
| Installed via | Homebrew |
| Config location | `~/.config/opencode/` |
| Surface | CLI |
| Model | qwen3:8b via Ollama |

---

## VS Code

| Item | Value |
|------|-------|
| Version | x.x.x |
| Installed via | Homebrew Cask |
| App location | `/Applications/Visual Studio Code.app` |
| User settings | `~/Library/Application Support/Code/User/settings.json` |
| Extensions location | `~/.vscode/extensions/` |
| Surface | IDE |

### Installed extensions

| Extension | Purpose |
|-----------|---------|
| Continue | AI assistant — connected to qwen3:8b via Ollama |

---

## Model configuration

| Setting | Value |
|---------|-------|
| Config file | `frugal-vibe.conf` in repo root |
| MODEL_PROVIDER | ollama |
| LOCAL_MODEL | qwen3:8b |
| PAID_MODEL | claude-haiku-4-5 (not active — requires ANTHROPIC_API_KEY in shell environment) |

---

## API keys

API keys are not stored here. They live in your shell environment (`~/.zshrc` on macOS/Linux, Windows Environment Variables).

To check whether a key is set, run:

```bash
echo $ANTHROPIC_API_KEY     # should print your key, or nothing if not set
echo $OPENAI_API_KEY
```

---

## Notes

*Add any personal notes about your setup here — things that were different from the default, decisions you made, or issues you ran into and resolved.*
