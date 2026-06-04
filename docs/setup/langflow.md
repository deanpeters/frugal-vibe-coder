# Setting Up LangFlow

## The problem it solves

The no-code and CLI surfaces connect a prompt to a model and return a response. That works well for single-turn questions. But many real product workflows are more complex: you want to retrieve information from a document, pass it through a prompt, combine it with other context, and route the result to a tool. Wiring that up by hand — even with a good CLI tool — means writing code.

LangFlow lets you design those multi-step AI pipelines visually. You drag components onto a canvas, connect them together, and see data flow through the system as you test it. The result is a working AI pipeline — built without writing code.

## What it is

LangFlow is a free, open-source visual builder for AI applications. It runs locally as a web app you start from your terminal and access in your browser. Components represent models, prompts, retrievers, tools, and other building blocks. You connect them into a flow and run it.

LangFlow connects to Ollama natively — no API key required for local use.

## What you're about to do

Install LangFlow via pipx, start it, build a simple flow that connects a prompt to your Ollama model, and confirm it runs. This takes about 20–30 minutes, including download time.

**Prerequisites:**
- Ollama installed and running with `qwen3:8b` ([guide](ollama.md))
- Python 3.10 or newer installed (3.11 or 3.12 recommended)

---

## Fastest path with this repo

If you already have this repo on your machine and want the guided version of this setup:

- macOS / Linux: run `./scripts/install-langflow.sh`

The script checks Python, installs pipx if needed, installs LangFlow, and walks you through starting it. Use the rest of this guide to understand the concepts and steps in more detail.

---

## Check if you already have LangFlow

Run this in your terminal:

```bash
langflow --version
```

If it returns a version number, LangFlow is installed. Skip to [Start LangFlow](#start-langflow).

---

## Install Python

LangFlow requires Python 3.10 or newer (3.11 or 3.12 work best).

Check what you have:

```bash
python3 --version
```

**Python 3.10–3.12:** continue to the next step.

**Older Python or no Python:**

- **macOS with Homebrew:** `brew install python`
- **Linux (Debian/Ubuntu/Mint):** `sudo apt install python3 python3-pip`

---

## Install pipx

pipx installs Python command-line apps in isolated environments, which prevents dependency conflicts with other Python tools you might have installed.

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

---

## Install LangFlow

```bash
pipx install langflow
```

LangFlow has a large set of dependencies — this download will take several minutes. When it finishes, the `langflow` command is available.

---

## Start LangFlow

LangFlow runs as a local server. Start it in your terminal:

```bash
langflow run
```

Wait until you see output that includes `Application startup complete`. Then open your browser to:

```
http://localhost:7860
```

**To stop it:** press `Ctrl+C` in the terminal where it's running.

---

## Connect LangFlow to Ollama

When building a flow, you add AI model components to the canvas. To use Ollama:

1. In the component sidebar (left panel), search for **Ollama**
2. Drag an **Ollama** component onto the canvas
3. In the component settings:
   - Set **Base URL** to: `http://localhost:11434`
   - Set **Model Name** to: `qwen3:8b`
4. Connect the Ollama component to other components in your flow

LangFlow will use your local model — no API key required.

---

## Build a basic flow

A minimal working flow has three components:

1. **Chat Input** — receives a message from the user
2. **Prompt** — formats the message into a prompt for the model
3. **Ollama** — sends the prompt to your local model and returns a response

Connect them in that order: Chat Input → Prompt → Ollama.

Click **Run** or use the Playground panel to test the flow with a message.

---

## Verify it's working

In the Playground panel, type:

> "Summarize the key steps for writing a good product brief."

If you get a response, your flow is connected to Ollama and running correctly.

---

## Starting LangFlow in future sessions

LangFlow doesn't start automatically when you turn on your computer. Each session, run:

```bash
langflow run
```

Then open `http://localhost:7860` in your browser.

---

## What you now have

A visual AI pipeline builder running locally on your machine, connected to your free Ollama model. You can design multi-step AI workflows using a canvas, test them in the browser, and iterate on them — without writing code and without paying for API access.

**Want to understand the concepts behind this?** See [/docs/concepts/what-is-a-flow-builder.md](../concepts/what-is-a-flow-builder.md).

---

**Want to go deeper?**
LangFlow documentation covers components, integrations, deployment, and building agents: [docs.langflow.org](https://docs.langflow.org)
