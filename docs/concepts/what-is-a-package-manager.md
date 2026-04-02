# What is a Package Manager?

## The problem it solves

Installing software the traditional way means hunting down a website, downloading an installer, clicking through a wizard, and hoping it works. When you need to update that software later, you do it all again. When something breaks, you're not sure what changed or how to fix it.

A package manager removes all of that friction.

## What it is

A package manager is a tool that installs, updates, and removes software on your computer — using a single command instead of a browser and a download folder.

You tell it what you want. It handles the rest.

## How it works

Package managers connect to a central registry of software — think of it like an app store you control from the terminal. When you ask for something, it:

1. Looks up the software by name
2. Downloads the right version for your system
3. Installs it in the right place
4. Keeps a record so it can update or remove it later

You don't need to know where the software lives or how it's structured. The package manager knows.

## Why it matters for your setup

Almost every tool in this repo — Ollama, OpenCode, VS Code — can be installed through a package manager. That means:

- **One command to install** instead of visiting multiple websites
- **One command to update** when a new version comes out
- **A clean record** of what's installed and where
- **Easy removal** if you change your mind

It also makes it easier to follow guides written by others, since most developer documentation assumes you have one.

## Which package manager you'll use

| Platform | Package manager | How to get it |
|---------|----------------|--------------|
| macOS | Homebrew | [brew.sh](https://brew.sh) — one command to install |
| Windows | Chocolatey | [chocolatey.org](https://chocolatey.org/install) — follow the install guide |
| Debian / Ubuntu / Mint | apt | Already installed — nothing to do |

The setup guides in this repo will check whether you have one and use it automatically when available.

## What this unlocks

Once you have a package manager, installing the tools in this repo becomes fast and consistent. It also means you can follow almost any developer setup guide you find online — most of them assume you have one.

---

**Want to go deeper?**
Homebrew's own getting started guide is one of the clearest introductions to what package managers do and why: [docs.brew.sh](https://docs.brew.sh)
