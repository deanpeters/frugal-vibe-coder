# Setting Up Open WebUI

## The problem it solves

Ollama runs AI models on your machine — but it has no user-facing interface. To talk to a model, you'd normally need to use a terminal command or another app. Open WebUI adds a browser-based chat interface that looks and feels like ChatGPT, except it's running entirely on your own machine using the Ollama model you already installed.

## What it is

Open WebUI is a free, open-source, locally hosted chat interface. You start it from your terminal once, then access it in any browser at `http://localhost:8080`. It works with Ollama out of the box, supports multiple conversations, and keeps everything on your machine.

## What you're about to do

Install Open WebUI via pipx, connect it to your local Ollama model, and verify it works with a quick test conversation. This takes about 10–15 minutes, most of which is download time.

**Prerequisites:**
- Ollama installed and running with `qwen3:8b` ([guide](ollama.md))
- Python 3.10 or newer installed

---

## Fastest path with this repo

If you already have this repo on your machine and want the guided version of this setup:

- macOS / Linux: run `./scripts/install-open-webui.sh`

The script checks Python, installs pipx if needed, installs Open WebUI, and walks you through starting it.

Use the rest of this guide if you want to install manually or understand the setup in more detail.

---

## Check if you already have Open WebUI

Run this in your terminal:

```bash
open-webui --version
```

If it returns a version number, Open WebUI is installed. Skip to [Start Open WebUI](#start-open-webui).

If the command isn't found, continue below.

---

## Install Python

Open WebUI requires Python 3.10 or newer.

Check what you have:

```bash
python3 --version
```

**Python 3.10 or newer:** continue to the next step.

**Older Python or no Python:**

- **macOS with Homebrew:** `brew install python`
- **Linux (Debian/Ubuntu/Mint):** `sudo apt install python3 python3-pip`

---

## Install pipx

pipx installs Python command-line apps in isolated environments — safer than installing them directly into your system Python.

**macOS with Homebrew:**

```bash
brew install pipx
pipx ensurepath
```

**Linux (Debian/Ubuntu/Mint):**

```bash
sudo apt install pipx
pipx ensurepath
```

What `pipx ensurepath` does: adds the pipx-managed apps folder to your shell PATH so the `open-webui` command is available in future terminal sessions.

---

## Install Open WebUI

```bash
pipx install open-webui
```

This downloads Open WebUI and its dependencies. It may take a few minutes. When it finishes, the `open-webui` command is available.

---

## Start Open WebUI

Open WebUI runs as a local server — you start it in a terminal and access it in your browser.

```bash
open-webui serve
```

Wait until you see output that includes `Application startup complete`. Then open your browser to:

```
http://localhost:8080
```

**To stop it:** press `Ctrl+C` in the terminal where it's running.

---

## First launch

The first time you open Open WebUI, it will ask you to create a local admin account. This account is stored on your machine — no email verification or cloud sign-up required. Choose any username and password you'll remember.

---

## Connect Open WebUI to Ollama

Open WebUI looks for Ollama automatically when both are running. If it connects successfully, you'll see your Ollama models available in the model selector.

If it doesn't connect automatically:

1. Go to **Settings** (gear icon, top right)
2. Select **Connections**
3. Set the Ollama URL to: `http://localhost:11434`
4. Click Save

**Model to use:** `qwen3:8b` (or whatever you have installed in Ollama)

---

## Verify it's working

In the chat input, type:

> "What's one thing a PM should do at the start of a new project?"

If you get a thoughtful response, Open WebUI is connected to Ollama and working correctly.

---

## Starting Open WebUI in future sessions

Open WebUI doesn't start automatically when you turn on your computer. Each session, run:

```bash
open-webui serve
```

Then open `http://localhost:8080` in your browser.

---

## What you now have

A private, browser-based chat interface powered by your local Ollama model. It supports multiple conversations, remembers your chat history, and lets you switch between any models you have installed in Ollama — all without sending data to the internet or paying for API access.

**Next step:** head to [/docs/surfaces/no-code.md](../surfaces/no-code.md) for workflow guidance on the no-code surface.

---

**Want to go deeper?**
Open WebUI documentation covers model management, system prompts, RAG, and multi-user configuration: [docs.openwebui.com](https://docs.openwebui.com)
