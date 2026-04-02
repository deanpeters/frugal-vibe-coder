# Docs

This is the learning core of frugal-vibe-coder. If you're not sure where to start, use the table below.

---

## Fastest path

If you want the shortest route to a working setup:

- first get the repo onto your machine by downloading the GitHub ZIP or cloning it
- macOS / Linux: run `./scripts/setup.sh`
- Windows: run `.\scripts\setup.ps1` in PowerShell as Administrator

Those guided scripts explain each step, check what is already installed, verify manual installs before moving on, and write a local setup record to `docs/reference/my-setup.md`.

If you prefer to read first and install one tool at a time, keep going below.

---

## Where to look

| What you need | Where to go |
|--------------|------------|
| Understand a concept (package managers, git, Ollama, API keys) | [/concepts](concepts/) |
| Install a tool step by step | [/setup](setup/) |
| Learn how to use a surface (no-code, CLI, IDE) | [/surfaces](surfaces/) |
| Find a config file location or check what's installed | [/reference](reference/) |

---

## If you're just starting

1. If you want the easiest route, run the guided setup script for your platform
2. Read [What is Ollama?](concepts/what-is-ollama.md) if you want the mental model first
3. Choose a surface and follow its setup guide: [Dyad](setup/dyad.md) · [OpenCode](setup/opencode.md) · [VS Code](setup/vscode.md)
4. Check [/reference](reference/) any time you need to find a config or see what's installed

---

## How these docs are written

Every guide follows the same pattern:
- starts with the problem it solves
- explains what the thing is in plain language
- tells you what you're about to do before you do it
- explains every step as you go
- ends with what you now have and what it makes possible

No step is left unexplained. No jargon without a definition.
