# What is Ollama?

## The problem it solves

Most AI tools work by sending your questions to a server somewhere on the internet. That server runs the AI model, generates a response, and sends it back. Every query costs money — either yours or the company's. Your data leaves your machine. If you're offline, nothing works.

Ollama lets you run AI models directly on your own computer instead.

## What it is

Ollama is a free, open-source tool that downloads AI models and runs them locally — on your machine, using your hardware, without sending anything to the internet.

Once it's installed and a model is downloaded, it works offline. Every query is free. Your data stays with you.

## How it works

Ollama runs quietly in the background as a local server. When a tool like Dyad, OpenCode, or VS Code needs to talk to an AI model, it sends a request to Ollama on your own machine — the same way it would talk to a cloud service, except nothing leaves your computer.

You choose which model to run. Ollama downloads it once and keeps it ready.

## The model this repo starts with

**`qwen3:8b`** — a general-purpose model that runs well on ordinary consumer hardware (8–16 GB RAM, no GPU required).

This model is well suited to the kinds of questions PMs and designers ask: what should I build, how should I think about this problem, why isn't this working the way I expected. It handles conversation, reasoning, and explanation — not just code.

You download it once. After that, it's on your machine and costs nothing to use.

## What "8b" means

The `8b` refers to the size of the model — 8 billion parameters. Think of parameters as the learned knowledge baked into the model. Larger models generally perform better but require more memory and run more slowly. For learning on a consumer laptop, 8b is a good balance.

You don't need to understand the details. Just know that bigger is not always better for your hardware.

## What this unlocks

Once Ollama is running with `qwen3:8b`, all three learning surfaces in this repo are ready to use:

- **Dyad** (no-code) — can use your local model as its AI engine
- **OpenCode** (CLI) — connects to Ollama for code and conversation assistance
- **VS Code** (IDE) — extensions can route to Ollama instead of a paid service

You have a working AI assistant on your machine before spending a cent.

---

**Want to go deeper?**
Ollama's model library shows every model available and what each one is suited for: [ollama.com/library](https://ollama.com/library)
