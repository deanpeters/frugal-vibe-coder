# Setting Up VS Code

## The problem it solves

At some point you'll want to look at the code an AI generated, understand it, modify it, and make it your own. Visual builders abstract the code away. The terminal shows you text. A code editor puts you directly inside the files, with tools that help you read, navigate, and change them.

VS Code is where you develop transferable skills — the kind that work regardless of which AI tool you use next.

## What it is

VS Code (Visual Studio Code) is a free, open-source code editor made by Microsoft. It is the most widely used editor in the world, works on all platforms, and has a large ecosystem of extensions. It can connect to your local Ollama model so the AI assistance stays free and local.

## What you're about to do

Install VS Code, add a minimal set of extensions for AI-assisted development, and configure it to use your local Ollama model. This takes about 15 minutes.

**Prerequisite:** Ollama installed and running with `qwen3:8b` ([guide](ollama.md)).

---

## Fastest path with this repo

If you already have this repo on your machine and want the guided version of this setup:

- macOS / Linux: run `./scripts/install-vscode.sh`
- Windows: run `.\scripts\setup.ps1` and choose VS Code in Step 3

The script version installs Continue when possible, asks before replacing an existing Continue config, and creates a backup if you choose replace.

Use the rest of this guide if you want to install or configure VS Code manually.

---

## Check if you already have VS Code

Open Terminal (Mac/Linux) or PowerShell (Windows) and run:

```bash
code --version
```

**You see a version number** → VS Code is already installed.

- Want to update it? VS Code updates itself — open it and check Help → Check for Updates.
- Ready to configure it? Skip to [Install extensions](#install-extensions).

**You see `command not found`** → VS Code is not installed. Continue below.

---

## Install VS Code

### macOS

**With Homebrew (recommended):**

```bash
brew install --cask visual-studio-code
```

What this does: installs VS Code as a desktop application via Homebrew.

**Without Homebrew:**

Download from [code.visualstudio.com](https://code.visualstudio.com), open the `.dmg`, and drag VS Code to your Applications folder.

After installing via either method, enable the `code` command in Terminal:
- Open VS Code
- Press `Cmd+Shift+P` to open the command palette
- Type "shell command" and select **Shell Command: Install 'code' command in PATH**

---

### Windows

**With Chocolatey (recommended):**

```powershell
choco install vscode
```

**Without Chocolatey:**

Download from [code.visualstudio.com](https://code.visualstudio.com) and run the installer. During install, check the box for **Add to PATH** — this lets you open VS Code from the terminal later.

---

### Linux — Debian, Ubuntu, Mint

```bash
sudo apt install software-properties-common apt-transport-https curl
curl -sSL https://packages.microsoft.com/keys/microsoft.asc | sudo apt-key add -
sudo add-apt-repository "deb [arch=amd64] https://packages.microsoft.com/repos/vscode stable main"
sudo apt update
sudo apt install code
```

What this does: adds Microsoft's official package repository to your system and installs VS Code from it. This ensures you get official updates through `apt` going forward.

---

## Install extensions

VS Code's power comes from extensions. For this setup, you need exactly one required extension.

Open VS Code, then open the Extensions panel (`Ctrl+Shift+X` on Windows/Linux, `Cmd+Shift+X` on Mac).

### Required: Continue — an AI assistant that connects to Ollama

Search for **Continue** and install it.

What it does: adds an AI chat panel and inline suggestions to VS Code, and supports Ollama as a local provider — meaning your AI assistance stays free and on your machine.

## Configure Continue to use Ollama

If you use `./scripts/install-vscode.sh`, this configuration step can be done for you. If you already have a Continue config, the script asks before replacing it and backs it up first.

After installing Continue:

1. Click the Continue icon in the left sidebar (it looks like a chat bubble)
2. Click the settings/gear icon
3. Under **Models**, click **Add Model**
4. Select **Ollama** as the provider
5. Select **qwen3:8b** as the model
6. Click Save

Continue will connect to your local Ollama instance. You'll see the model listed as active in the Continue panel.

---

## Verify it's working

Open any file in VS Code (or create a new one). In the Continue panel on the left, type:

> "What does a product requirements document typically include?"

Continue will respond using your local `qwen3:8b` model. If you get a response, everything is connected and working.

---

## What you now have

A code editor with AI assistance running entirely on your machine. You can open generated code, ask questions about it, make changes, and build real understanding of what the AI is producing — without a subscription or cloud dependency.

**Next step:** head to [/docs/surfaces/ide.md](../surfaces/ide.md) to learn how to use VS Code effectively for AI-assisted development.

---

**Want to go deeper?**
The Continue documentation covers its full feature set and how to configure different models and providers: [docs.continue.dev](https://docs.continue.dev)
