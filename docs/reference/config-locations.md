# Config Locations

Where each tool stores its settings on your machine. Use this when you need to edit a config directly, troubleshoot a setting, or understand what a tool is reading.

---

## frugal-vibe.conf

The main config file for this repo. Controls which model provider and model your tools use.

| Platform | Location |
|---------|---------|
| All platforms | `frugal-vibe.conf` in the root of this repo |

For personal overrides that you don't want to commit, create `frugal-vibe.conf.local` in the same location. It is gitignored.

**What it controls:** `MODEL_PROVIDER`, `LOCAL_MODEL`, `PAID_MODEL`
**Does it contain API keys?** No — never. Keys live in your shell environment only.

---

## Ollama

Ollama stores its models and settings in a hidden folder in your home directory.

| Platform | Config and models location |
|---------|--------------------------|
| macOS | `~/.ollama/` |
| Windows | `%USERPROFILE%\.ollama\` |
| Linux | `~/.ollama/` |

Models are stored in `~/.ollama/models/`. The `qwen3:8b` model file lives there after you run `ollama pull qwen3:8b`.

**Useful commands:**

```bash
ollama list              # see all downloaded models
ollama show qwen3:8b     # details about a specific model
ollama rm model-name     # remove a model to free up space
```

---

## Dyad

Dyad stores its application data and settings in your system's standard app data folder.

| Platform | Location |
|---------|---------|
| macOS | `~/Library/Application Support/Dyad/` |
| Windows | `%APPDATA%\Dyad\` |
| Linux | `~/.config/dyad/` |

**Model settings** are configured within the Dyad interface — open Dyad, go to Settings, and look for the model or provider section.

---

## OpenCode

OpenCode stores its configuration in a dedicated folder in your home directory.

| Platform | Location |
|---------|---------|
| macOS | `~/.config/opencode/` |
| Windows | `%APPDATA%\opencode\` |
| Linux | `~/.config/opencode/` |

The main config file is typically `config.json` or `config.toml` inside that folder. Run `opencode config` to edit settings through the interactive interface rather than editing the file directly.

---

## VS Code

VS Code has two types of settings: user settings (apply everywhere) and workspace settings (apply only to the current project folder).

### User settings

| Platform | Location |
|---------|---------|
| macOS | `~/Library/Application Support/Code/User/settings.json` |
| Windows | `%APPDATA%\Code\User\settings.json` |
| Linux | `~/.config/Code/User/settings.json` |

Open user settings directly in VS Code with `Cmd+Shift+P` (Mac) or `Ctrl+Shift+P` (Windows/Linux), then type "Open User Settings (JSON)".

### Workspace settings

Stored in a `.vscode/settings.json` file inside your project folder. These override user settings for that project only. This file is safe to commit for settings you want to share — personal settings should stay in user settings.

### Extensions

All installed extensions live in:

| Platform | Location |
|---------|---------|
| macOS / Linux | `~/.vscode/extensions/` |
| Windows | `%USERPROFILE%\.vscode\extensions\` |

---

## Continue (VS Code extension)

Continue stores its own configuration separately from VS Code.

| Platform | Location |
|---------|---------|
| macOS / Linux | `~/.continue/config.json` |
| Windows | `%USERPROFILE%\.continue\config.json` |

This is where your model and provider settings are stored. You can edit it directly or use the Continue settings UI inside VS Code.

**What a typical Ollama configuration looks like in this file:**

```json
{
  "models": [
    {
      "title": "qwen3:8b",
      "provider": "ollama",
      "model": "qwen3:8b"
    }
  ]
}
```

---

## API keys

API keys are not stored in any config file in this repo. They live in your shell environment.

| Platform | Where to set them |
|---------|-----------------|
| macOS / Linux | `~/.zshrc` or `~/.bashrc` — add `export ANTHROPIC_API_KEY=your-key` |
| Windows | System → Advanced system settings → Environment Variables |

For more detail, see [What is an API key?](../concepts/what-is-an-api-key.md)
