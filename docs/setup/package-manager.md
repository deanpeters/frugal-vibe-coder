# Setting Up a Package Manager

## The problem it solves

Without a package manager, installing software means visiting websites, downloading files, running installers, and repeating the whole process every time something needs an update. It's slow and easy to get wrong.

A package manager lets you install, update, and remove software with a single command — and keeps a clean record of everything you've installed.

If you're not sure what a package manager is, read [What is a package manager?](../concepts/what-is-a-package-manager.md) first.

## What you're about to do

Check whether you already have a package manager, and install one if you don't. This takes 5–10 minutes and only needs to be done once.

---

## macOS — Homebrew

### Check if you already have it

Open Terminal (`Applications → Utilities → Terminal`) and run:

```bash
brew --version
```

**You see a version number** (e.g., `Homebrew 4.x.x`) → Homebrew is already installed.

- Want to update it? Run `brew update` and move on.
- Happy with what you have? Move on.

**You see `command not found`** → Homebrew is not installed. Continue below.

### Install Homebrew

Run this command in Terminal:

```bash
/bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
```

What this does: downloads the Homebrew installer from its official source and runs it. It will ask for your Mac password (the one you use to log in) — this is normal, it needs permission to install software.

Follow any prompts. The installer will tell you when it's done.

### Verify the install

```bash
brew --version
```

You should see a version number. Homebrew is ready.

---

## Windows — Chocolatey

### Check if you already have it

Open PowerShell as Administrator (search for PowerShell in the Start menu, right-click, choose "Run as administrator") and run:

```powershell
choco --version
```

**You see a version number** (e.g., `2.x.x`) → Chocolatey is already installed.

- Want to update it? Run `choco upgrade chocolatey` and move on.
- Happy with what you have? Move on.

**You see an error** → Chocolatey is not installed. Continue below.

### Install Chocolatey

In the same Administrator PowerShell window, run:

```powershell
Set-ExecutionPolicy Bypass -Scope Process -Force; [System.Net.ServicePointManager]::SecurityProtocol = [System.Net.ServicePointManager]::SecurityProtocol -bor 3072; iex ((New-Object System.Net.WebClient).DownloadString('https://community.chocolatey.org/install.ps1'))
```

What this does: downloads and runs the official Chocolatey installer. Running as Administrator is required because it installs software at the system level.

### Verify the install

```powershell
choco --version
```

You should see a version number. Chocolatey is ready.

---

## Linux — Debian, Ubuntu, Mint — apt

### You already have it

`apt` comes pre-installed on Debian, Ubuntu, and Mint. There is nothing to install.

### Make sure it's up to date

Open Terminal and run:

```bash
sudo apt update
```

What this does: refreshes the list of available software so that when you install something, you get the latest version. It does not install or change anything yet — it just updates the list.

You'll be asked for your password. This is normal.

### Verify it's working

```bash
apt --version
```

You should see a version number. apt is ready.

---

## What you now have

A package manager installed and ready. Every tool in the remaining setup guides will use it when available, giving you cleaner installs and one-command updates going forward.

**Next step:** [Install Ollama](ollama.md)

---

**Want to go deeper?**
Homebrew's documentation explains the full range of what it can do: [docs.brew.sh](https://docs.brew.sh)
