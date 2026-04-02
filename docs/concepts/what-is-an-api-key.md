# What is an API Key?

## The problem it solves

Paid AI services — like Claude (Anthropic) or ChatGPT (OpenAI) — need to know who is making each request so they can charge the right account and control access. An API key is how they do that.

You probably won't need one to get started. This repo defaults to local models through Ollama, which are free and require no account. But when you're ready to try a paid model, this is what you'll need.

## What it is

An API key is a long string of characters — something like `sk-ant-abc123...` — that acts as a secret password between your computer and a paid service.

Every time your tools send a request to that service, the key goes along with it. The service uses it to identify you, log your usage, and bill your account.

## Why it needs to be kept secret

If someone else gets your API key, they can use it to make requests that get charged to your account. Depending on the service and how much they use it, this can add up quickly.

The two rules:
1. **Never put your API key in a file** — especially not one that might be shared or committed to git
2. **Store it in your shell environment** — a part of your system that tools can access but that doesn't get saved to files or sent anywhere

This repo enforces both. The `frugal-vibe.conf` config file has no field for API keys by design. If a setup script needs one, it will read it from your environment — and if it's not there, it will tell you exactly where to add it.

## Where to store your key

**On macOS or Linux**, open your shell profile in a text editor:

```bash
~/.zshrc       # if you use zsh (default on modern macOS)
~/.bashrc      # if you use bash
```

Add this line, replacing the placeholder with your actual key:

```bash
export ANTHROPIC_API_KEY=your-key-here
```

Save the file. Then run `source ~/.zshrc` (or open a new terminal window) for it to take effect.

**On Windows**, go to:
System → Advanced system settings → Environment Variables → New (under User variables)

Set the name to `ANTHROPIC_API_KEY` and the value to your key.

## The supported providers and their cheapest starting models

| Provider | Key name | Default model | Where to get a key |
|---------|---------|--------------|-------------------|
| Anthropic | `ANTHROPIC_API_KEY` | `claude-haiku-4-5` | console.anthropic.com |
| OpenAI | `OPENAI_API_KEY` | `gpt-4o-mini` | platform.openai.com |

Both default to the cheapest available model. You can change this in `frugal-vibe.conf`.

## What this unlocks

Once your key is in your environment, you can switch `MODEL_PROVIDER` in `frugal-vibe.conf` from `ollama` to `anthropic` or `openai` and your tools will use that provider instead — without touching any code.

Switch back to `ollama` any time.

---

**Want to go deeper?**
Anthropic's guide to API key security covers best practices in plain language: [docs.anthropic.com/en/api/getting-started](https://docs.anthropic.com/en/api/getting-started)
