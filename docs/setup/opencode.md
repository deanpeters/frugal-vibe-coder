# Setting Up OpenCode

## The problem it solves

Visual builders are great for first steps, but they can feel like a black box — you describe something, something happens, and you're not sure what. The terminal puts you closer to the process. You see exactly what the AI is doing, what files it's creating, and why.

OpenCode is a CLI-based AI coding agent. It runs in your terminal, uses your local Ollama model, and makes the building process visible and controllable.

## What it is

OpenCode is a free, open-source, terminal-based AI agent for building and editing code. You interact with it through text prompts in your terminal. It reads and writes files on your machine, explains what it's doing, and lets you approve or adjust each step.

## What you're about to do

Install OpenCode, configure it to use your local Ollama model, and run a quick test to confirm it's working. This takes about 10 minutes.

**Prerequisite:** Ollama installed and running with `qwen3:8b` ([guide](ollama.md)).

---

## Fastest path with this repo

If you already have this repo on your machine and want the guided version of this setup:

- macOS / Linux: run `./scripts/install-opencode.sh`
- Windows: run `.\scripts\setup.ps1` and choose OpenCode in Step 3

The script version checks whether Ollama is ready first, asks before changing an existing config, and creates a backup if you choose to replace that config.

Use the rest of this guide if you want to install or configure OpenCode manually.

---

## Check if you already have OpenCode

Open Terminal (Mac/Linux) or PowerShell (Windows) and run:

```bash
opencode --version
```

**You see a version number** → OpenCode is already installed.

- Want to update it? Follow the [update instructions](#updating-opencode) below.
- Ready to use it? Skip to [Configure OpenCode to use Ollama](#configure-opencode-to-use-ollama).

**You see `command not found`** → OpenCode is not installed. Continue below.

---

## Install OpenCode

### macOS

**With Homebrew (recommended):**

```bash
brew install opencode
```

**Without Homebrew:**

```bash
curl -fsSL https://opencode.ai/install | sh
```

What this does: downloads the official OpenCode install script and runs it. It installs OpenCode and makes it available from anywhere in your terminal.

---

### Windows

**With Chocolatey (recommended):**

```powershell
choco install opencode
```

**Without Chocolatey:**

Download the Windows binary from [opencode.ai](https://opencode.ai), extract it, and add it to your PATH. The OpenCode website has step-by-step instructions for this.

---

### Linux — Debian, Ubuntu, Mint

```bash
curl -fsSL https://opencode.ai/install | sh
```

What this does: downloads the official install script from opencode.ai and runs it. OpenCode will be installed and ready to use from your terminal.

---

## Configure OpenCode to use Ollama

If you use `./scripts/install-opencode.sh`, this configuration step can be done for you. If you already have an OpenCode config, the script asks before replacing it and backs it up first.

OpenCode needs a valid config file that points to your local Ollama server.

Create or update `~/.config/opencode/config.json` with:

```json
{
  "$schema": "https://opencode.ai/config.json",
  "provider": {
    "ollama": {
      "npm": "@ai-sdk/openai-compatible",
      "name": "Ollama (local)",
      "options": {
        "baseURL": "http://localhost:11434/v1"
      },
      "models": {
        "qwen3:8b": {
          "name": "qwen3:8b (local)"
        }
      }
    }
  },
  "model": "ollama/qwen3:8b"
}
```

This tells OpenCode to route requests to your local Ollama instance instead of a cloud service, and it sets `qwen3:8b` as the default model.

---

## Verify it's working

Navigate to an empty folder:

```bash
mkdir my-first-opencode-project
cd my-first-opencode-project
```

Start OpenCode:

```bash
opencode
```

Try a simple prompt:

> "Create a plain text file called notes.txt with three bullet points about what a product manager does"

OpenCode will show you what it plans to do before doing it. Confirm, and it will create the file. Open `notes.txt` to verify the contents.

Type `/exit` or press `Ctrl+C` to close OpenCode.

---

## Updating OpenCode

**macOS (Homebrew):**
```bash
brew upgrade opencode
```

**Windows (Chocolatey):**
```powershell
choco upgrade opencode
```

**Linux:**
```bash
curl -fsSL https://opencode.ai/install | sh
```

---

## What you now have

A terminal-based AI agent connected to your local model. You can use it to build, edit, and explore projects — with full visibility into what the AI is doing at each step.

**Next step:** head to [/docs/surfaces/cli.md](../surfaces/cli.md) to learn how to use OpenCode effectively.

---

**Want to go deeper?**
OpenCode's documentation covers its full command set and configuration: [opencode.ai/docs](https://opencode.ai/docs)
