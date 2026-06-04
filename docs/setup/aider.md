# Setting Up Aider

## The problem it solves

When you're working on an existing project, the workflow changes. You're not describing something new from scratch — you're asking for a specific change to code that already exists. Keeping the AI aligned with what's already in the files, across multiple files, without losing track of what changed and why, is harder than it sounds.

Aider is built for exactly this workflow. It reads your entire project, understands how the pieces connect, and makes precise file edits based on your instructions — showing you a diff before anything is saved.

## What it is

Aider is a free, open-source AI pair programming tool that runs in your terminal. It builds a map of your codebase, edits files directly based on your instructions, and integrates with git so every change is tracked. It works with your local Ollama model — no API key required to get started.

## What you're about to do

Install Aider via pipx, configure it to use your local Ollama model, and run it against a small project to verify it works. This takes about 10–15 minutes.

**Prerequisites:**
- Ollama installed and running with `qwen3:8b` ([guide](ollama.md))
- Python 3.10 or newer installed
- A project folder with at least a few files to work on

---

## Fastest path with this repo

If you already have this repo on your machine:

- macOS / Linux: run `./scripts/install-aider.sh`

The script installs Aider via pipx, writes a default config pointing to Ollama, and confirms the install. Use the rest of this guide to understand the details.

---

## Check if you already have Aider

```bash
aider --version
```

If it returns a version number, Aider is installed. Skip to [Using Aider with Ollama](#using-aider-with-ollama).

---

## Install Python

Aider requires Python 3.10 or newer.

```bash
python3 --version
```

**macOS with Homebrew:** `brew install python`
**Linux (Debian/Ubuntu/Mint):** `sudo apt install python3 python3-pip`

---

## Install pipx

```bash
# macOS with Homebrew
brew install pipx && pipx ensurepath

# Linux
sudo apt install pipx && pipx ensurepath
```

---

## Install Aider

```bash
pipx install aider-chat
```

Note: the package name is `aider-chat` but the command is `aider`.

---

## Using Aider with Ollama

Tell Aider which Ollama model to use by specifying it on the command line:

```bash
aider --model ollama/qwen3:8b
```

Or set it as the default in a config file so you don't need to type it every time. Create `~/.aider.conf.yml`:

```yaml
model: ollama/qwen3:8b
```

After that, you can just run:

```bash
aider
```

---

## Run Aider on a project

Move into a project folder — ideally one that's already a git repository:

```bash
cd ~/my-project
aider
```

You'll see Aider start up and show the files it has indexed. Type a plain-language instruction:

> "Add a comment to each function explaining what it does"

Aider will show you a diff of the proposed changes. Type `y` to apply them, `n` to skip.

---

## If your project isn't in git yet

Aider works best with git because it tracks what changed. If you don't have git set up on your project:

```bash
cd ~/my-project
git init
git add .
git commit -m "Initial commit"
```

Then run Aider.

---

## How Aider differs from OpenCode and Goose

| | OpenCode | Goose | Aider |
|--|----------|-------|-------|
| Primary focus | Guided new builds | General tasks | Editing existing code |
| Best for | Starting a project | Varied workflows | Iterating on what exists |
| File handling | Generates new files | Reads and edits files | Diffs and patches files |
| Git integration | Optional | Optional | Built-in |
| Works with Ollama | Yes | Yes | Yes |

Use Aider when you have working code that you want to improve, extend, or understand — and you want precise, reviewable changes.

---

## What you now have

A terminal-based AI coding partner that understands your existing project and makes targeted, reviewable edits — powered by your local Ollama model at no cost per query.

---

**Want to go deeper?**
Aider's documentation covers repo maps, multi-file edits, git integration, and model selection: [aider.chat](https://aider.chat)
