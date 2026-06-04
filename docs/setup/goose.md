# Setting Up Goose

## The problem it solves

OpenCode is designed for one thing: AI-assisted coding. But a lot of what PMs and builders actually do isn't coding — it's research, summarization, file organization, writing, and workflow automation. Asking a coding-focused tool to help with those tasks works, but it's not what the tool was built for.

Goose is a general-purpose AI agent. It can write code, run commands, read and edit files, search the web, and work across different tasks in a single session — guided by you.

## What it is

Goose is a free, open-source AI agent that runs on your machine as a CLI tool. It supports 15+ model providers including Ollama, meaning it can run entirely on your local model without any API cost. Goose is part of the Linux Foundation's Agentic AI Foundation, making it a community-governed project rather than a proprietary tool.

## What you're about to do

Install the Goose CLI, connect it to your local Ollama model, and run a short session to verify it's working. This takes about 10 minutes.

**Prerequisite:** Ollama installed and running with `qwen3:8b` ([guide](ollama.md)).

---

## Fastest path with this repo

If you already have this repo on your machine:

- macOS / Linux: run `./scripts/install-goose.sh`

The script installs the Goose CLI, guides you through `goose configure`, and records the install. Use the rest of this guide to understand the steps in more detail.

---

## Check if you already have Goose

```bash
goose --version
```

If it returns a version number, Goose is installed. Skip to [Connect Goose to Ollama](#connect-goose-to-ollama).

---

## Install Goose

Goose installs via an official install script that downloads the correct binary for your platform.

**macOS and Linux:**

```bash
curl -fsSL https://github.com/aaif-goose/goose/releases/download/stable/download_cli.sh | bash
```

What this does: downloads the Goose binary and places it in `~/.local/bin`. It does not require root or sudo.

After installation, open a new terminal window or run:

```bash
export PATH="$HOME/.local/bin:$PATH"
```

Verify it installed:

```bash
goose --version
```

---

## Connect Goose to Ollama

Run the interactive configuration:

```bash
goose configure
```

When prompted:

1. Choose **Ollama** as the provider
2. Set the model to: `qwen3:8b`
3. Set the base URL to: `http://localhost:11434` (if asked)

Goose will test the connection and confirm it's working.

---

## Verify it's working

Start a session:

```bash
goose session
```

Type a question or task, for example:

> "What files are in my current directory and what do they do?"

Goose will look at your files and respond. If you get a meaningful response, everything is working correctly.

To exit a session: type `exit` or press `Ctrl+D`.

---

## How Goose differs from OpenCode

| | OpenCode | Goose |
|--|----------|-------|
| Primary focus | Coding tasks | General-purpose tasks |
| Best for | New projects, guided builds | Research, automation, varied work |
| Approval model | Step-by-step with review | Session-based with confirmation |
| Interface | Terminal | Terminal |
| Works with Ollama | Yes | Yes |

Use OpenCode when you're building something new and want structured guidance. Use Goose when you need an agent that can range across different kinds of tasks in a single session.

---

## Starting Goose in future sessions

```bash
goose session
```

Or for a one-off task:

```bash
goose run --text "your task here"
```

---

## What you now have

A general-purpose AI agent running on your machine, powered by your local Ollama model. It can help with code, research, writing, file work, and workflow automation — without cloud dependency or API cost.

---

**Want to go deeper?**
Goose documentation covers extensions, MCP tools, and multi-provider configuration: [goose-docs.ai](https://goose-docs.ai)
