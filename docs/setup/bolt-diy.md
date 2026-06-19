# Setting Up bolt.diy

## The problem it solves

Dyad is the fastest way to build a first working app locally. But when you want more control over the output — downloadable code, more complex app structures, or side-by-side diffs of what the AI changed — you need something closer to the metal. bolt.diy gives you that, while still running entirely on your machine.

## What it is

bolt.diy is a free, open-source, browser-based app builder. You describe what you want in plain language, and bolt.diy generates a working app in the browser — then lets you download or extend the code. It supports 20+ model providers including Ollama, so it can run locally without any API cost.

bolt.diy is the open-source version of bolt.new, maintained by StackBlitz Labs.

## What you're about to do

Clone bolt.diy to your machine, install its dependencies, connect it to your local Ollama model, and build something small to confirm it's working. This takes 10–20 minutes, depending on your internet connection.

**Prerequisites:**
- Ollama installed and running with `qwen3:8b` ([guide](ollama.md))
- Node.js 18 or later
- git
- pnpm

The install script handles all of these if they're missing.

---

## Fastest path with this repo

If you already have this repo on your machine:

- macOS / Linux: run `./scripts/install-bolt-diy.sh`

The script checks prerequisites, clones bolt.diy to `~/bolt.diy`, installs dependencies, and writes Ollama connection settings. Use the rest of this guide if you want to install manually or understand what the script does.

---

## Check if you already have bolt.diy

```bash
ls ~/bolt.diy
```

If a directory appears, bolt.diy is already cloned. Skip to [Start bolt.diy](#start-bolt-diy).

---

## Install prerequisites

### Node.js

```bash
node --version
```

If this returns a version (e.g. `v20.11.0`), you're set. If not:

- **macOS with Homebrew:** `brew install node`
- **Linux:** `sudo apt install nodejs npm`
- **All platforms:** download the LTS version from [nodejs.org](https://nodejs.org)

### git

```bash
git --version
```

If not installed:
- **macOS:** `brew install git` or run `xcode-select --install`
- **Linux:** `sudo apt install git`

### pnpm

bolt.diy uses pnpm (a fast alternative to npm) to manage its dependencies.

```bash
pnpm --version
```

If not installed:

```bash
# macOS with Homebrew
brew install pnpm

# All platforms
npm install -g pnpm
```

---

## Clone bolt.diy

This downloads the bolt.diy source code to your machine.

```bash
git clone https://github.com/stackblitz-labs/bolt.diy ~/bolt.diy
```

What this does: creates a `~/bolt.diy` folder with the full bolt.diy codebase. About 50 MB.

---

## Install dependencies

```bash
cd ~/bolt.diy
pnpm install
```

What this does: downloads the Node.js packages that bolt.diy depends on. This can take 2–5 minutes on first run. You will not see much output while it runs — that is normal.

---

## Configure Ollama

Create a `.env.local` file in the bolt.diy folder to tell it where your Ollama instance is running:

```bash
echo "OLLAMA_API_BASE_URL=http://localhost:11434" >> ~/bolt.diy/.env.local
echo "DEFAULT_NUM_CTX=32768" >> ~/bolt.diy/.env.local
```

What this does: sets the Ollama endpoint so bolt.diy can find your local model. No API key required.

---

## Start bolt.diy

```bash
cd ~/bolt.diy && pnpm run dev
```

Wait for the terminal to show something like:

```
Local:   http://localhost:5173/
```

Then open your browser and go to: `http://localhost:5173`

To stop bolt.diy: press `Ctrl+C` in the terminal where it's running.

---

## Connect bolt.diy to Ollama

When bolt.diy is open in your browser:

1. Click the **settings icon** (gear or wrench, top right)
2. Under **Model Provider**, select **Ollama**
3. Under **Model**, choose `qwen3:8b`
4. Click Save or Confirm

bolt.diy will connect to your local Ollama instance. No API key required.

---

## Verify it's working

In bolt.diy, type a prompt:

> "Build me a simple habit tracker with a list and a way to add habits"

bolt.diy will generate a working app in the browser. If you can see and interact with it, everything is connected.

---

## Starting bolt.diy in future sessions

bolt.diy does not run as a background service. Each time you want to use it, start the dev server:

```bash
cd ~/bolt.diy && pnpm run dev
```

Then open `http://localhost:5173` in your browser.

---

## How bolt.diy differs from Dyad

| | Dyad | bolt.diy |
|--|------|----------|
| Setup difficulty | Simple — desktop app | Moderate — requires Node.js, git, pnpm |
| Interface | Desktop application | Browser tab |
| Output | App preview | Downloadable code |
| App complexity | Simple to moderate | Moderate to complex |
| Ollama support | Yes | Yes |
| Best for | First app, fast prototyping | Iterating on real code |

Start with Dyad for your first app. Move to bolt.diy when you want to inspect or keep the code it generates.

---

## Updating bolt.diy

```bash
cd ~/bolt.diy
git pull
pnpm install
```

---

## What you now have

A browser-based AI app builder running entirely on your machine, powered by your local Ollama model. You can prototype ideas, generate real downloadable code, and iterate on apps in natural language — without cloud dependency or API cost.

---

**Want to go deeper?**
bolt.diy documentation covers provider configuration, deployment, and advanced features: [bolt.diy GitHub](https://github.com/stackblitz-labs/bolt.diy)
