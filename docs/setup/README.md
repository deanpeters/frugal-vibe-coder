# Setup Guides

These guides walk you through installing everything you need, one tool at a time. Each guide checks what you already have before doing anything, explains every step, and tells you what you now have when it's done.

---

## Easiest option

If you want the repo to guide you through setup, start here instead of doing each tool by hand:

First get the repo onto your machine by downloading the GitHub ZIP or cloning it.

From the repo root:

**macOS / Linux**
```bash
./scripts/setup.sh
```

**Windows** (PowerShell as Administrator)
```powershell
.\scripts\setup.ps1
```

Those scripts:
- walk you through the recommended order
- ask before changing anything
- verify manual installs before continuing
- back up an existing config before replacing it
- update `docs/reference/my-setup.md` so you can see what changed

Use the rest of this section if you prefer tool-by-tool guides or want to understand each install manually.

---

## Recommended order

Work through these in order. Each one builds on the previous.

| Step | Guide | What it gives you |
|------|-------|------------------|
| 1 | [Package manager](package-manager.md) | A fast, clean way to install and update software |
| 2 | [Ollama](ollama.md) | A local AI model running on your own machine |
| 3 | [Dyad](dyad.md) | A no-code app builder connected to your local model |
| 4 | [OpenCode](opencode.md) | A CLI agent for AI-assisted building in the terminal |
| 5 | [VS Code](vscode.md) | A code editor set up for AI-assisted development |

You don't have to install all five. If you only want the no-code path, steps 1–3 are enough. If you want the CLI path, steps 1, 2, and 4. If you want the IDE path, steps 1, 2, and 5.

---

## Before you start

- You'll need an internet connection for the initial downloads
- You'll need to open a terminal (Mac/Linux) or PowerShell (Windows) for some steps — the guides will tell you when and how
- If a concept in a guide is unfamiliar, the [/concepts](../concepts/) docs have plain-language explanations

---

## Your install log

As you complete each guide, the setup scripts will record what was installed and where in `docs/reference/my-setup.md`. That file is local to your machine and never shared. Check it any time you want to see what you have and where its config lives.

If you rerun setup later, the scripts update the relevant sections instead of piling up duplicate entries.
