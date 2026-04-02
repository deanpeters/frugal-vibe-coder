# Setting Up Ollama

## The problem it solves

Most AI tools send your questions to a server on the internet, charge per query, and require a live connection to work. Ollama runs an AI model directly on your own computer — free, private, and available offline once set up.

If you're not sure what Ollama is, read [What is Ollama?](../concepts/what-is-ollama.md) first.

## What you're about to do

Install Ollama, download the `qwen3:8b` model, and verify that everything is running. This takes 10–20 minutes depending on your internet speed (the model download is about 5 GB).

**Prerequisite:** a package manager installed ([guide](package-manager.md)).

---

## Check if you already have Ollama

Open Terminal (Mac/Linux) or PowerShell (Windows) and run:

```bash
ollama --version
```

**You see a version number** (e.g., `ollama version 0.x.x`) → Ollama is already installed.

- Want to update it? Follow the [update instructions](#updating-ollama) below.
- Already have `qwen3:8b`? Run `ollama list` to check. If it's listed, skip to [Verify Ollama is running](#verify-ollama-is-running).
- Happy with what you have? Skip to [Pull the model](#pull-the-model).

**You see `command not found`** → Ollama is not installed. Continue below.

---

## Install Ollama

### macOS

**With Homebrew (recommended):**

```bash
brew install ollama
```

What this does: downloads and installs Ollama using Homebrew, so it can be updated with a single command later.

**Without Homebrew:**

Download the macOS installer from [ollama.com/download](https://ollama.com/download), open the `.dmg` file, and drag Ollama to your Applications folder.

---

### Windows

**With Chocolatey (recommended):**

Open PowerShell as Administrator and run:

```powershell
choco install ollama
```

**Without Chocolatey:**

Download the Windows installer from [ollama.com/download](https://ollama.com/download) and run it.

---

### Linux — Debian, Ubuntu, Mint

Run this command in Terminal:

```bash
curl -fsSL https://ollama.com/install.sh | sh
```

What this does: downloads the official Ollama install script from ollama.com and runs it. It will install Ollama and set it up to run automatically in the background.

---

## Pull the model

Once Ollama is installed, download the default model. Run this in Terminal or PowerShell:

```bash
ollama pull qwen3:8b
```

What this does: downloads the `qwen3:8b` model to your machine. It is about 5 GB, so this may take a few minutes depending on your connection. You only need to do this once — the model stays on your machine.

You'll see a progress bar. When it reaches 100%, the download is complete.

---

## Verify Ollama is running

Check that Ollama is active:

```bash
ollama list
```

You should see `qwen3:8b` listed. That means the model is downloaded and ready.

Try a quick test:

```bash
ollama run qwen3:8b "What is a product manager?"
```

Ollama will respond directly in your terminal. This is your local AI model, running entirely on your machine. Press `Ctrl+D` or type `/bye` to exit.

---

## Updating Ollama

**macOS (Homebrew):**
```bash
brew upgrade ollama
```

**Windows (Chocolatey):**
```powershell
choco upgrade ollama
```

**Linux:**
Re-run the install script — it will update in place:
```bash
curl -fsSL https://ollama.com/install.sh | sh
```

---

## What you now have

A local AI model running on your machine. All three learning surfaces — Dyad, OpenCode, and VS Code — can connect to it. Every query is free and private.

**Next step:** pick your surface:
- [Dyad](dyad.md) — no-code, fastest first success
- [OpenCode](opencode.md) — CLI, more transparency and control
- [VS Code](vscode.md) — IDE, direct code work

---

**Want to go deeper?**
Ollama's model library shows every available model and what each is suited for: [ollama.com/library](https://ollama.com/library)
