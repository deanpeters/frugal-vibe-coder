# What is a Config File?

## The problem it solves

Scripts and tools have settings — which model to use, which provider to connect to, how to behave in different situations. Those settings could be hardcoded inside the scripts themselves, but that would mean editing code every time you want to change something. For most people, that's uncomfortable and error-prone.

A config file separates the settings from the scripts, so you can change your setup by editing one simple file — without touching anything that could break.

## What it is

A config file is a plain text file that holds settings for your tools. It is designed to be read and edited by humans, not just computers.

Each line sets one value. The format is simple:

```
SETTING_NAME=value
```

Lines that start with `#` are comments — plain English explanations of what each setting does. They're there for you, not the script.

## How frugal-vibe.conf works

This repo uses a single config file called `frugal-vibe.conf`. It controls which AI model and provider your tools use. Here's what it looks like:

```bash
# Model provider to use: ollama | anthropic | openai
MODEL_PROVIDER=ollama

# Local model (used when MODEL_PROVIDER=ollama)
LOCAL_MODEL=qwen3:8b

# Paid model — defaults to cheapest available
# anthropic: claude-haiku-4-5 | claude-sonnet-4-6
# openai:    gpt-4o-mini | gpt-4o
PAID_MODEL=claude-haiku-4-5
```

To switch from a local model to a paid one, you change one line:

```bash
MODEL_PROVIDER=anthropic
```

That's it. The scripts read this file and adjust their behavior accordingly.

## What the config file does not contain

API keys. Never.

The config file is safe to share and commit to git because it contains no secrets. API keys live in your shell environment (see [What is an API Key?](what-is-an-api-key.md)).

## Personal overrides

If you want to customize your setup in a way you don't want to share — for example, pointing to a different model or using a different provider temporarily — create a file called `frugal-vibe.conf.local`. It works the same way as `frugal-vibe.conf` and overrides it, but it is gitignored and never committed.

## What this unlocks

With `frugal-vibe.conf` in place, you have a single place to control your entire model and provider setup. You can switch between local and paid models in seconds, without touching any scripts, and without breaking anything.

---

**Want to go deeper?**
The `.env` file format — which this config follows — is explained clearly here: [12factor.net/config](https://12factor.net/config)
