# setup.ps1
# Main entry point for setting up frugal-vibe-coder on Windows.
#
# Usage (run in PowerShell as Administrator):
#   .\scripts\setup.ps1
#
# This script walks you through installing everything in the recommended order:
#   1. Chocolatey package manager (if not already present)
#   2. Ollama + default model
#   3. Your chosen learning surface(s): Dyad, OpenCode, VS Code
#
# Mac/Linux users: use scripts/setup.sh instead.

# ---------------------------------------------------------------------------
# Require Administrator privileges
# ---------------------------------------------------------------------------
if (-not ([Security.Principal.WindowsPrincipal] [Security.Principal.WindowsIdentity]::GetCurrent()).IsInRole([Security.Principal.WindowsBuiltInRole]::Administrator)) {
    Write-Host ""
    Write-Host "This script must be run as Administrator." -ForegroundColor Red
    Write-Host "Right-click PowerShell and choose 'Run as administrator', then try again." -ForegroundColor Yellow
    Write-Host ""
    exit 1
}

# ---------------------------------------------------------------------------
# Helper functions
# ---------------------------------------------------------------------------

function Print-Header($text) {
    Write-Host ""
    Write-Host "================================================" -ForegroundColor Blue
    Write-Host "  $text" -ForegroundColor Blue
    Write-Host "================================================" -ForegroundColor Blue
    Write-Host ""
}

function Print-Step($text) {
    Write-Host "--> $text" -ForegroundColor White
}

function Print-Success($text) {
    Write-Host "OK  $text" -ForegroundColor Green
}

function Print-Warn($text) {
    Write-Host "!   $text" -ForegroundColor Yellow
}

function Print-Error($text) {
    Write-Host "X   $text" -ForegroundColor Red
}

function Print-Info($text) {
    Write-Host "    $text"
}

function Ask-YesNo($prompt) {
    Write-Host ""
    $response = Read-Host "$prompt [y/n]"
    return $response -match '^[Yy]$'
}

function Ask-Choice($prompt, $options) {
    Write-Host ""
    Write-Host $prompt -ForegroundColor White
    Write-Host ""
    for ($i = 0; $i -lt $options.Count; $i++) {
        Write-Host "  $($i + 1).  $($options[$i])"
    }
    Write-Host ""
    $choice = Read-Host "  Enter a number"
    return [int]$choice
}

function Is-Installed($command) {
    return $null -ne (Get-Command $command -ErrorAction SilentlyContinue)
}

function Load-Config {
    $configFile = Join-Path $PSScriptRoot "..\frugal-vibe.conf"
    $configLocal = Join-Path $PSScriptRoot "..\frugal-vibe.conf.local"

    # Defaults
    $global:MODEL_PROVIDER = "ollama"
    $global:LOCAL_MODEL = "qwen3:8b"
    $global:PAID_MODEL = "claude-haiku-4-5"

    foreach ($file in @($configFile, $configLocal)) {
        if (Test-Path $file) {
            Get-Content $file | ForEach-Object {
                if ($_ -match '^([^#=]+)=(.+)$') {
                    $key = $Matches[1].Trim()
                    $value = $Matches[2].Trim()
                    Set-Variable -Name $key -Value $value -Scope Global
                }
            }
        }
    }
}

function Write-StateRecord($tool, $version, $method, $configLocation, $surfaces) {
    $stateFile = Join-Path $PSScriptRoot "..\docs\reference\my-setup.md"
    $stateDir = Split-Path $stateFile

    if (-not (Test-Path $stateDir)) {
        New-Item -ItemType Directory -Path $stateDir -Force | Out-Null
    }

    if (-not (Test-Path $stateFile)) {
        $header = "# My Setup`n`n*Generated and updated by frugal-vibe-coder install scripts. Last updated: $(Get-Date -Format 'yyyy-MM-dd HH:mm')*`n`n---`n"
        Set-Content -Path $stateFile -Value $header
    }

    $entry = "`n## $tool`n`n| Item | Value |`n|------|-------|`n| Version | $version |`n| Installed via | $method |`n| Config location | ``$configLocation`` |`n| Surfaces supported | $surfaces |`n"
    Add-Content -Path $stateFile -Value $entry
    Print-Info "Install recorded in docs\reference\my-setup.md"
}

# ---------------------------------------------------------------------------
# Load configuration
# ---------------------------------------------------------------------------
Load-Config

# ---------------------------------------------------------------------------
# Welcome
# ---------------------------------------------------------------------------
Clear-Host
Print-Header "frugal-vibe-coder setup"

Print-Info "This script sets up your local AI-assisted learning environment."
Print-Info "It will check what you already have, explain each step, and ask"
Print-Info "before making any changes."
Write-Host ""
Print-Info "Nothing will be installed without your confirmation."
Write-Host ""
Print-Info "Current model configuration:"
Print-Info "  Provider: $global:MODEL_PROVIDER"
if ($global:MODEL_PROVIDER -eq "ollama") {
    Print-Info "  Model:    $global:LOCAL_MODEL  (local, free)"
} else {
    Print-Info "  Model:    $global:PAID_MODEL  (paid - requires API key)"
}
Write-Host ""

Read-Host "Press Enter to continue"

# ---------------------------------------------------------------------------
# Step 1 — Chocolatey
# ---------------------------------------------------------------------------
Print-Header "Step 1 of 4 - Package Manager"

Print-Info "A package manager installs and updates software from a single command."
Print-Info "Not sure what this is? Read: docs\concepts\what-is-a-package-manager.md"
Write-Host ""

if (Is-Installed "choco") {
    $chocoVersion = (choco --version 2>$null)
    Print-Success "Chocolatey is already installed  ($chocoVersion)"
    Print-Info "We'll use it for all installations."
} else {
    Print-Warn "Chocolatey is not installed."
    Write-Host ""

    if (Ask-YesNo "Install Chocolatey? (recommended)") {
        Print-Step "Installing Chocolatey..."
        Set-ExecutionPolicy Bypass -Scope Process -Force
        [System.Net.ServicePointManager]::SecurityProtocol = [System.Net.ServicePointManager]::SecurityProtocol -bor 3072
        Invoke-Expression ((New-Object System.Net.WebClient).DownloadString('https://community.chocolatey.org/install.ps1'))
        Print-Success "Chocolatey installed."

        # Refresh environment so choco is available in this session
        $env:Path = [System.Environment]::GetEnvironmentVariable("Path", "Machine") + ";" + [System.Environment]::GetEnvironmentVariable("Path", "User")
    } else {
        Print-Warn "Continuing without Chocolatey. Some tools will need manual installation."
    }
}

# ---------------------------------------------------------------------------
# Step 2 — Ollama
# ---------------------------------------------------------------------------
Print-Header "Step 2 of 4 - Ollama"

Print-Info "Ollama runs AI models locally - free, private, no internet required after setup."
Print-Info "Not sure what this is? Read: docs\concepts\what-is-ollama.md"
Write-Host ""

if (Ask-YesNo "Set up Ollama now?") {

    if (Is-Installed "ollama") {
        $ollamaVersion = (ollama --version 2>$null)
        Print-Success "Ollama is already installed  ($ollamaVersion)"
        Write-Host ""

        $choice = Ask-Choice "What would you like to do?" @(
            "Use the current version",
            "Update Ollama"
        )

        if ($choice -eq 2) {
            if (Is-Installed "choco") {
                choco upgrade ollama -y
            } else {
                Start-Process "https://ollama.com/download/windows"
                Print-Info "Download and run the latest installer from the page that just opened."
                Read-Host "Press Enter when done"
            }
        }
    } else {
        Print-Warn "Ollama is not installed."
        Write-Host ""

        Print-Step "Installing Ollama..."
        if (Is-Installed "choco") {
            choco install ollama -y
        } else {
            Start-Process "https://ollama.com/download/windows"
            Print-Info "Download and run the installer from the page that just opened."
            Read-Host "Press Enter when the install is complete"
        }
        Print-Success "Ollama installed."
    }

    # Pull the model
    Write-Host ""
    Print-Step "Checking for model: $global:LOCAL_MODEL..."

    $modelList = (ollama list 2>$null)
    if ($modelList -match $global:LOCAL_MODEL) {
        Print-Success "Model $global:LOCAL_MODEL is already downloaded."
    } else {
        Print-Info "Model $global:LOCAL_MODEL is not downloaded yet (~5 GB)."
        Write-Host ""

        if (Ask-YesNo "Download $($global:LOCAL_MODEL) now?") {
            Print-Step "Pulling model (this may take several minutes)..."
            ollama pull $global:LOCAL_MODEL
            Print-Success "Model $global:LOCAL_MODEL downloaded."
        } else {
            Print-Warn "Model not downloaded. Run later:  ollama pull $global:LOCAL_MODEL"
        }
    }

    Write-StateRecord "Ollama" (ollama --version 2>$null) "Chocolatey / installer" "$env:USERPROFILE\.ollama\" "No-code, CLI, IDE"
}

# ---------------------------------------------------------------------------
# Step 3 — Learning surfaces
# ---------------------------------------------------------------------------
Print-Header "Step 3 of 4 - Learning Surfaces"

Print-Info "Choose which surfaces to set up. You can install all three or just one."
Write-Host ""
Print-Info "  No-code  (Dyad)     - visual builder, fastest first success"
Print-Info "  CLI      (OpenCode) - terminal agent, transparency and control"
Print-Info "  IDE      (VS Code)  - code editor, long-term transferable skills"
Write-Host ""
Print-Info "Not sure? Read: docs\surfaces\README.md"
Write-Host ""

# Dyad
if (Ask-YesNo "Set up Dyad (no-code surface)?") {
    Print-Header "Installing Dyad"

    if (Is-Installed "choco") {
        choco install dyad -y
        Print-Success "Dyad installed."
    } else {
        Start-Process "https://dyad.sh"
        Print-Info "Download and run the Dyad installer from the page that just opened."
        Read-Host "Press Enter when the install is complete"
    }

    Write-Host ""
    Print-Info "When you open Dyad for the first time:"
    Print-Info "  1. Select Ollama as the provider"
    Print-Info "  2. Set the model to $global:LOCAL_MODEL"
    Print-Info "  3. Click Save"

    Write-StateRecord "Dyad" "installed" "Chocolatey / installer" "$env:APPDATA\Dyad\" "No-code"
}

# OpenCode
if (Ask-YesNo "Set up OpenCode (CLI surface)?") {
    Print-Header "Installing OpenCode"

    if (Is-Installed "opencode")) {
        Print-Success "OpenCode is already installed."
    } elseif (Is-Installed "choco") {
        choco install opencode -y
        Print-Success "OpenCode installed."
    } else {
        Start-Process "https://opencode.ai"
        Print-Info "Download OpenCode from the page that just opened."
        Read-Host "Press Enter when the install is complete"
    }

    # Write config
    $opencodeConfigDir = "$env:APPDATA\opencode"
    New-Item -ItemType Directory -Path $opencodeConfigDir -Force | Out-Null
    $opencodeConfig = @{
        provider = "ollama"
        model = $global:LOCAL_MODEL
    } | ConvertTo-Json
    Set-Content -Path "$opencodeConfigDir\config.json" -Value $opencodeConfig
    Print-Success "OpenCode configured to use $global:LOCAL_MODEL via Ollama."

    Write-StateRecord "OpenCode" "installed" "Chocolatey / installer" "$env:APPDATA\opencode\" "CLI"
}

# VS Code
if (Ask-YesNo "Set up VS Code (IDE surface)?") {
    Print-Header "Installing VS Code"

    if (Is-Installed "code") {
        $codeVersion = (code --version 2>$null | Select-Object -First 1)
        Print-Success "VS Code is already installed  ($codeVersion)"
    } elseif (Is-Installed "choco") {
        choco install vscode -y
        # Refresh PATH
        $env:Path = [System.Environment]::GetEnvironmentVariable("Path", "Machine") + ";" + [System.Environment]::GetEnvironmentVariable("Path", "User")
        Print-Success "VS Code installed."
    } else {
        Start-Process "https://code.visualstudio.com/download"
        Print-Info "Download VS Code from the page that just opened."
        Print-Info "During install, check 'Add to PATH' when prompted."
        Read-Host "Press Enter when the install is complete. Then close and reopen PowerShell."
    }

    # Install Continue extension
    if (Is-Installed "code") {
        Print-Step "Installing the Continue extension..."
        code --install-extension continue.continue --force
        Print-Success "Continue extension installed."

        # Configure Continue
        $continueConfigDir = "$env:USERPROFILE\.continue"
        New-Item -ItemType Directory -Path $continueConfigDir -Force | Out-Null
        $continueConfig = @{
            models = @(@{
                title = "$($global:LOCAL_MODEL) (local)"
                provider = "ollama"
                model = $global:LOCAL_MODEL
            })
        } | ConvertTo-Json -Depth 5
        Set-Content -Path "$continueConfigDir\config.json" -Value $continueConfig
        Print-Success "Continue configured to use $global:LOCAL_MODEL via Ollama."
    } else {
        Print-Warn "VS Code 'code' command not available yet."
        Print-Info "After restarting PowerShell, install the Continue extension manually:"
        Print-Info "  Open VS Code > Extensions (Ctrl+Shift+X) > search 'Continue' > Install"
    }

    Write-StateRecord "VS Code" (code --version 2>$null | Select-Object -First 1) "Chocolatey / installer" "$env:APPDATA\Code\User\settings.json" "IDE"
}

# ---------------------------------------------------------------------------
# Step 4 — Paid models (optional)
# ---------------------------------------------------------------------------
Print-Header "Step 4 of 4 - Paid Models (Optional)"

Print-Info "Your setup is complete and fully functional using free local models."
Print-Info ""
Print-Info "To add a paid model later, edit frugal-vibe.conf and set MODEL_PROVIDER."
Print-Info "Then add your API key as a Windows Environment Variable — never in a file."
Print-Info ""
Print-Info "  System > Advanced system settings > Environment Variables"
Print-Info "  Add: ANTHROPIC_API_KEY or OPENAI_API_KEY"
Print-Info ""
Print-Info "Full instructions: docs\concepts\what-is-an-api-key.md"

# ---------------------------------------------------------------------------
# Final summary
# ---------------------------------------------------------------------------
Print-Header "Setup complete"

Print-Success "Your frugal-vibe-coder environment is ready."
Write-Host ""
Print-Info "Where to go next:"
Print-Info "  Not sure where to start?  docs\surfaces\README.md"
Print-Info "  No-code guide:            docs\surfaces\no-code.md"
Print-Info "  CLI guide:                docs\surfaces\cli.md"
Print-Info "  IDE guide:                docs\surfaces\ide.md"
Print-Info "  Your install log:         docs\reference\my-setup.md"
Write-Host ""
