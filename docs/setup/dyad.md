# Setting Up Dyad

## The problem it solves

Getting to your first working app with AI usually requires navigating a terminal, writing code, or paying for a cloud service. Dyad removes all three barriers. It is a visual, no-code app builder that runs locally — powered by the Ollama model you already installed.

## What it is

Dyad is a free, open-source, locally installed app builder. You describe what you want to build in plain language, and Dyad generates and runs it. No coding required to get started. No API costs. No data leaving your machine.

## What you're about to do

Install Dyad, connect it to your local Ollama model, and build something small to confirm it's working. This takes about 10 minutes.

**Prerequisite:** Ollama installed and running with `qwen3:8b` ([guide](ollama.md)).

---

## Fastest path with this repo

If you already have this repo on your machine and want the guided version of this setup:

- macOS / Linux: run `./scripts/install-dyad.sh`
- Windows: run `.\scripts\setup.ps1` and choose Dyad in Step 3

The script version checks whether Ollama is ready first, verifies manual installs before continuing, and updates your local setup log when it is done.

Use the rest of this guide if you want to install Dyad manually or understand the setup in more detail.

---

## Check if you already have Dyad

Look for Dyad in your applications:

- **macOS** — check your Applications folder or Spotlight (`Cmd+Space`, type "Dyad")
- **Windows** — check the Start menu or search for "Dyad"
- **Linux** — check your application launcher or run `dyad --version` in Terminal

**Dyad is already installed:**

- Want to check for updates? Open Dyad — it will notify you if an update is available.
- Ready to use it? Skip to [Connect Dyad to Ollama](#connect-dyad-to-ollama).

**Dyad is not installed:** continue below.

---

## Install Dyad

### macOS

**With Homebrew (recommended):**

```bash
brew install --cask dyad
```

What this does: downloads and installs the Dyad desktop app via Homebrew, making future updates easy.

**Without Homebrew:**

1. Go to [dyad.sh](https://dyad.sh) and click Download
2. Open the downloaded `.dmg` file
3. Drag Dyad to your Applications folder

---

### Windows

**With Chocolatey (recommended):**

```powershell
choco install dyad
```

**Without Chocolatey:**

1. Go to [dyad.sh](https://dyad.sh) and click Download
2. Run the downloaded installer
3. Follow the prompts

---

### Linux — Debian, Ubuntu, Mint

1. Go to [dyad.sh](https://dyad.sh) and download the `.AppImage` or `.deb` file for Linux
2. For the `.deb` file, install it with:

```bash
sudo apt install ./dyad-*.deb
```

What this does: installs the Dyad package from the downloaded file. The `./` tells apt to install from a local file rather than the online registry.

---

## Connect Dyad to Ollama

When you open Dyad for the first time, it will ask you to choose a model provider.

1. Select **Ollama** as the provider
2. The model field should show `qwen3:8b` — if not, type it in
3. Click Save or Confirm

Dyad will connect to your local Ollama instance automatically. No API key required.

---

## Verify it's working

In Dyad, start a new project and type a simple prompt:

> "Build me a simple task tracker with a list and a way to add items"

Dyad will generate and display a working app. If you can see and interact with it, everything is connected and working.

---

## What you now have

A no-code app builder running entirely on your machine, powered by a free local model. You can prototype ideas, experiment freely, and build simple apps without writing code or spending money.

**Next step:** head to [/docs/surfaces/no-code.md](../surfaces/no-code.md) to learn how to use Dyad effectively.

---

**Want to go deeper?**
Dyad's documentation covers its full feature set and configuration options: [dyad.sh/docs](https://dyad.sh/docs)
