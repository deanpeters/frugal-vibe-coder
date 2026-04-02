# setup.ps1
# Main entry point for setting up frugal-vibe-coder on Windows.
#
# Usage (run in PowerShell as Administrator):
#   .\scripts\setup.ps1
#   .\scripts\setup.ps1 -ForceAll
#
# This script walks you through installing everything in the recommended order:
#   1. Chocolatey package manager (if not already present)
#   2. Ollama + default model
#   3. Your chosen learning surface(s): Dyad, OpenCode, VS Code
#
# Mac/Linux users: use scripts/setup.sh instead.

param(
    [switch]$ForceAll
)

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

function Run-WithStatus($label, [scriptblock]$action) {
    Print-Info "$label can take a few minutes on some machines."
    Print-Info "If you do not see new output immediately, the script is still working."
    Write-Host ""
    Write-Progress -Activity $label -Status "In progress..." -PercentComplete 0

    try {
        & $action
    }
    finally {
        Write-Progress -Activity $label -Completed
    }
}

function Ask-YesNo($prompt) {
    while ($true) {
        Write-Host ""
        $response = (Read-Host "$prompt [y/n]").Trim().ToLower()

        if ($response -in @("y", "yes")) {
            return $true
        }

        if ($response -in @("n", "no")) {
            return $false
        }

        Print-Warn "Please type y or n."
    }
}

function Ask-Choice($prompt, $options) {
    while ($true) {
        Write-Host ""
        Write-Host $prompt -ForegroundColor White
        Write-Host ""
        for ($i = 0; $i -lt $options.Count; $i++) {
            Write-Host "  $($i + 1).  $($options[$i])"
        }
        Write-Host ""
        $choice = Read-Host "  Enter a number"

        if ($choice -match '^\d+$') {
            $number = [int]$choice
            if ($number -ge 1 -and $number -le $options.Count) {
                return $number
            }
        }

        Print-Warn "Please enter a number from the list."
    }
}

function Press-EnterToContinue($prompt = "Press Enter to continue") {
    Write-Host ""
    Read-Host $prompt | Out-Null
}

function Is-Installed($command) {
    return $null -ne (Get-Command $command -ErrorAction SilentlyContinue)
}

function Get-ToolVersion($command) {
    switch ($command) {
        "choco" {
            if (Is-Installed "choco") { return (choco --version 2>$null) }
        }
        "ollama" {
            if (Is-Installed "ollama") { return (ollama --version 2>$null) }
        }
        "opencode" {
            if (Is-Installed "opencode") { return "installed" }
        }
        "code" {
            if (Test-VSCodeInstalled) { return "installed" }
        }
    }

    return ""
}

function Test-VSCodeInstalled {
    return (
        (Is-Installed "code") -or
        (Test-Path "$env:LOCALAPPDATA\Programs\Microsoft VS Code\Code.exe") -or
        (Test-Path "$env:ProgramFiles\Microsoft VS Code\Code.exe")
    )
}

function Test-DyadInstalled {
    return (
        (Is-Installed "dyad") -or
        (Test-Path "$env:LOCALAPPDATA\Programs\Dyad\Dyad.exe") -or
        (Test-Path "$env:ProgramFiles\Dyad\Dyad.exe")
    )
}

function Wait-ForCheck($label, [scriptblock]$test) {
    while ($true) {
        Press-EnterToContinue "Press Enter after you've finished installing $label, and I'll check it"

        if (& $test) {
            Print-Success "$label is installed."
            return $true
        }

        Print-Warn "$label still isn't showing as installed."
        Print-Info "If the installer is still open, finish that first, then check again."

        $choice = Ask-Choice "What would you like to do?" @(
            "Check again",
            "Exit for now and come back later"
        )

        if ($choice -eq 2) {
            return $false
        }
    }
}

function Backup-FileIfExists($filePath, $label) {
    if (-not (Test-Path $filePath)) {
        return
    }

    $backupPath = "$filePath.bak.$(Get-Date -Format 'yyyyMMdd-HHmmss')"
    Copy-Item -Path $filePath -Destination $backupPath -Force
    Print-Info "Backed up your existing $label to:"
    Print-Info "  $backupPath"
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

function Initialize-StateFile {
    $stateFile = Join-Path $PSScriptRoot "..\docs\reference\my-setup.md"
    $stateDir = Split-Path $stateFile

    if (-not (Test-Path $stateDir)) {
        New-Item -ItemType Directory -Path $stateDir -Force | Out-Null
    }

    if (-not (Test-Path $stateFile)) {
        $header = "# My Setup`n`n*Generated and updated by frugal-vibe-coder install scripts. Last updated: $(Get-Date -Format 'yyyy-MM-dd HH:mm')*`n`n---`n"
        Set-Content -Path $stateFile -Value $header
        return $stateFile
    }

    $content = Get-Content -Path $stateFile -Raw
    $timestamp = Get-Date -Format 'yyyy-MM-dd HH:mm'

    if ($content -match 'Last updated: .*?\*') {
        $content = [regex]::Replace($content, 'Last updated: .*?\*', "Last updated: $timestamp*")
        Set-Content -Path $stateFile -Value $content
    }

    return $stateFile
}

function Write-StateSection($tool, $content) {
    $stateFile = Initialize-StateFile
    $existing = Get-Content -Path $stateFile -Raw
    $pattern = "(?ms)^## " + [regex]::Escape($tool) + "\r?\n.*?(?=^## |\z)"
    $updated = [regex]::Replace($existing, $pattern, "").TrimEnd()
    $section = "`r`n`r`n## $tool`r`n`r`n$content`r`n"
    Set-Content -Path $stateFile -Value ($updated + $section)
}

function Write-StateRecord($tool, $version, $method, $configLocation, $surfaces) {
    $entry = "| Item | Value |`n|------|-------|`n| Version | $version |`n| Installed via | $method |`n| Config location | ``$configLocation`` |`n| Surfaces supported | $surfaces |"
    Write-StateSection $tool $entry
    Print-Info "Install recorded in docs\reference\my-setup.md"
}

$global:PROGRESS_FILE = Join-Path $PSScriptRoot "..\docs\reference\setup-progress.env"

function Setup-ProgressExists {
    return (Test-Path $global:PROGRESS_FILE)
}

function Write-SetupProgressFile($currentStep, $lastCompletedStep, $nextStep) {
    $progressDir = Split-Path $global:PROGRESS_FILE

    if (-not (Test-Path $progressDir)) {
        New-Item -ItemType Directory -Path $progressDir -Force | Out-Null
    }

    $content = @(
        "# Local progress checkpoint for guided setup scripts"
        "CURRENT_STEP=$currentStep"
        "LAST_COMPLETED_STEP=$lastCompletedStep"
        "NEXT_STEP=$nextStep"
        "UPDATED_AT=$(Get-Date -Format 'yyyy-MM-dd HH:mm')"
    )

    Set-Content -Path $global:PROGRESS_FILE -Value $content
}

function Get-SetupProgressValue($key) {
    if (-not (Test-Path $global:PROGRESS_FILE)) {
        return ""
    }

    $line = Get-Content $global:PROGRESS_FILE | Where-Object { $_ -like "$key=*" } | Select-Object -First 1
    if (-not $line) {
        return ""
    }

    return $line.Substring($key.Length + 1)
}

function Get-SetupCurrentStep {
    return (Get-SetupProgressValue "CURRENT_STEP")
}

function Get-SetupLastCompletedStep {
    return (Get-SetupProgressValue "LAST_COMPLETED_STEP")
}

function Get-SetupNextStep {
    $nextStep = Get-SetupProgressValue "NEXT_STEP"
    if ($nextStep) {
        return $nextStep
    }

    return "package_manager"
}

function Describe-SetupStep($step) {
    switch ($step) {
        "package_manager" { return "Step 1 of 4 - Package Manager" }
        "ollama" { return "Step 2 of 4 - Ollama" }
        "dyad" { return "Step 3 of 4 - Dyad" }
        "opencode" { return "Step 3 of 4 - OpenCode" }
        "vscode" { return "Step 3 of 4 - VS Code" }
        "paid_models" { return "Step 4 of 4 - Paid Models" }
        default { return $step }
    }
}

function Mark-SetupStepStarted($step) {
    $lastCompletedStep = Get-SetupLastCompletedStep
    Write-SetupProgressFile $step $lastCompletedStep $step
}

function Mark-SetupStepComplete($completedStep, $nextStep) {
    Write-SetupProgressFile "" $completedStep $nextStep
}

function Clear-SetupProgress {
    if (Test-Path $global:PROGRESS_FILE) {
        Remove-Item $global:PROGRESS_FILE -Force
    }
}

function Print-SetupResumeMessage {
    $nextStep = Get-SetupNextStep

    if (-not (Setup-ProgressExists) -or $nextStep -eq "package_manager") {
        return
    }

    Print-Info "I found a previous setup session that did not finish."
    Print-Info "We'll continue from: $(Describe-SetupStep $nextStep)"
    Print-Info "Your local checkpoint is saved at:"
    Print-Info "  $global:PROGRESS_FILE"
    Write-Host ""
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

if ($ForceAll) {
    Clear-SetupProgress
    Print-Info "Force-all mode is on."
    Print-Info "We'll revisit all four setup steps from the top for testing."
    Print-Info "You will still be asked before anything changes."
    Write-Host ""
} else {
    Print-SetupResumeMessage
}

Press-EnterToContinue

# ---------------------------------------------------------------------------
# Step 1 — Chocolatey
# ---------------------------------------------------------------------------
if ($ForceAll) {
    $nextStep = "package_manager"
} else {
    $nextStep = Get-SetupNextStep
}

if ($nextStep -eq "package_manager") {
    Mark-SetupStepStarted "package_manager"

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
            Run-WithStatus "Installing Chocolatey" {
                Set-ExecutionPolicy Bypass -Scope Process -Force
                [System.Net.ServicePointManager]::SecurityProtocol = [System.Net.ServicePointManager]::SecurityProtocol -bor 3072
                Invoke-Expression ((New-Object System.Net.WebClient).DownloadString('https://community.chocolatey.org/install.ps1'))
            }
            Print-Success "Chocolatey installed."

            # Refresh environment so choco is available in this session
            $env:Path = [System.Environment]::GetEnvironmentVariable("Path", "Machine") + ";" + [System.Environment]::GetEnvironmentVariable("Path", "User")
        } else {
            Print-Warn "Continuing without Chocolatey. Some tools will need manual installation."
        }
    }

    Mark-SetupStepComplete "package_manager" "ollama"
    $nextStep = "ollama"
}

# ---------------------------------------------------------------------------
# Step 2 — Ollama
# ---------------------------------------------------------------------------
if ($nextStep -eq "ollama") {
    Mark-SetupStepStarted "ollama"

    Print-Header "Step 2 of 4 - Ollama"

    Print-Info "Ollama runs AI models locally - free, private, no internet required after setup."
    Print-Info "Not sure what this is? Read: docs\concepts\what-is-ollama.md"
    Write-Host ""

    if (Ask-YesNo "Set up Ollama now?") {
        $ollamaInstallMethod = "existing"

        if (Is-Installed "ollama") {
            $ollamaVersion = Get-ToolVersion "ollama"
            Print-Success "Ollama is already installed  ($ollamaVersion)"
            Print-Info "Next, choose whether to keep this version or update it."
            Write-Host ""

            $choice = Ask-Choice "What would you like to do?" @(
                "Use the current version",
                "Update Ollama"
            )

            if ($choice -eq 2) {
                if (Is-Installed "choco") {
                    Run-WithStatus "Updating Ollama" { choco upgrade ollama -y }
                    $ollamaInstallMethod = "Chocolatey"
                } else {
                    Start-Process "https://ollama.com/download/windows"
                    Print-Info "Download and run the latest installer from the page that just opened."
                    if (-not (Wait-ForCheck "Ollama" { Is-Installed "ollama" })) {
                        Print-Info "Stopping here for now. Run .\scripts\setup.ps1 again when you're ready."
                        exit 0
                    }
                    $ollamaInstallMethod = "manual installer"
                }
            }
        } else {
            Print-Warn "Ollama is not installed."
            Write-Host ""

            Print-Step "Installing Ollama..."
            if (Is-Installed "choco") {
                Run-WithStatus "Installing Ollama" { choco install ollama -y }
                $ollamaInstallMethod = "Chocolatey"
            } else {
                Start-Process "https://ollama.com/download/windows"
                Print-Info "Download and run the installer from the page that just opened."
                if (-not (Wait-ForCheck "Ollama" { Is-Installed "ollama" })) {
                    Print-Info "Stopping here for now. Run .\scripts\setup.ps1 again when you're ready."
                    exit 0
                }
                $ollamaInstallMethod = "manual installer"
            }
            Print-Success "Ollama installed."
        }

        if (-not (Is-Installed "ollama")) {
            Print-Warn "Ollama setup did not finish yet."
            Print-Info "We'll stop here so you can pick back up at Ollama next time."
            Print-Info "Your local checkpoint is saved at:"
            Print-Info "  $global:PROGRESS_FILE"
            exit 0
        }

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
                Print-Info "You should see model download progress below."
                Print-Info "If it pauses briefly, it may still be downloading or unpacking files."
                Write-Host ""
                Run-WithStatus "Downloading $($global:LOCAL_MODEL)" { ollama pull $global:LOCAL_MODEL }
                Print-Success "Model $global:LOCAL_MODEL downloaded."
            } else {
                Print-Warn "Model not downloaded. Run later:  ollama pull $global:LOCAL_MODEL"
            }
        }

        Write-StateRecord "Ollama" (Get-ToolVersion "ollama") $ollamaInstallMethod "$env:USERPROFILE\.ollama\" "No-code, CLI, IDE"
    }

    Mark-SetupStepComplete "ollama" "dyad"
    $nextStep = "dyad"
}

# ---------------------------------------------------------------------------
# Step 3 — Learning surfaces
# ---------------------------------------------------------------------------
if ($nextStep -in @("dyad", "opencode", "vscode")) {
    Print-Header "Step 3 of 4 - Learning Surfaces"

    Print-Info "Choose which surfaces to set up. You can install all three or just one."
    Write-Host ""
    Print-Info "  No-code  (Dyad)     - visual builder, fastest first success"
    Print-Info "  CLI      (OpenCode) - terminal agent, transparency and control"
    Print-Info "  IDE      (VS Code)  - code editor, long-term transferable skills"
    Write-Host ""
    Print-Info "Not sure? Read: docs\surfaces\README.md"
    Write-Host ""
}

if ($nextStep -eq "dyad") {
    Mark-SetupStepStarted "dyad"

    if (Ask-YesNo "Set up Dyad (no-code surface)?") {
        if (-not (Is-Installed "ollama")) {
            Print-Warn "Dyad setup needs Ollama first."
            Print-Info "Install Ollama in Step 2, then run this script again so Dyad can use your local model."
            Print-Info "We'll stop here so you can pick back up at Dyad next time."
            Print-Info "Your local checkpoint is saved at:"
            Print-Info "  $global:PROGRESS_FILE"
            exit 0
        } else {
            Print-Header "Installing Dyad"
            $dyadInstallMethod = "existing"

            if (Test-DyadInstalled) {
                Print-Success "Dyad is already installed."
            } elseif (Is-Installed "choco") {
                Run-WithStatus "Installing Dyad" { choco install dyad -y }
                Print-Success "Dyad installed."
                $dyadInstallMethod = "Chocolatey"
            } else {
                Start-Process "https://dyad.sh"
                Print-Info "Download and run the Dyad installer from the page that just opened."
                if (-not (Wait-ForCheck "Dyad" { Test-DyadInstalled })) {
                    Print-Info "Stopping here for now. Run .\scripts\setup.ps1 again when you're ready."
                    exit 0
                }
                $dyadInstallMethod = "manual installer"
            }

            if (-not (Test-DyadInstalled)) {
                Print-Warn "Dyad setup did not finish yet."
                Print-Info "We'll stop here so you can pick back up at Dyad next time."
                Print-Info "Your local checkpoint is saved at:"
                Print-Info "  $global:PROGRESS_FILE"
                exit 0
            }

            Write-Host ""
            Print-Info "When you open Dyad for the first time:"
            Print-Info "  1. Select Ollama as the provider"
            Print-Info "  2. Set the model to $global:LOCAL_MODEL"
            Print-Info "  3. Click Save"

            Write-StateRecord "Dyad" "installed" $dyadInstallMethod "$env:APPDATA\Dyad\" "No-code"
        }
    }

    Mark-SetupStepComplete "dyad" "opencode"
    $nextStep = "opencode"
}

if ($nextStep -eq "opencode") {
    Mark-SetupStepStarted "opencode"

    if (Ask-YesNo "Set up OpenCode (CLI surface)?") {
        if (-not (Is-Installed "ollama")) {
            Print-Warn "OpenCode setup needs Ollama first."
            Print-Info "Install Ollama in Step 2, then run this script again so OpenCode can use your local model."
            Print-Info "We'll stop here so you can pick back up at OpenCode next time."
            Print-Info "Your local checkpoint is saved at:"
            Print-Info "  $global:PROGRESS_FILE"
            exit 0
        } else {
            Print-Header "Installing OpenCode"
            $opencodeInstallMethod = "existing"
            $opencodeConfigStatus = "Existing OpenCode config left unchanged."

            if (Is-Installed "opencode") {
                Print-Success "OpenCode is already installed."
            } elseif (Is-Installed "choco") {
                Run-WithStatus "Installing OpenCode" { choco install opencode -y }
                Print-Success "OpenCode installed."
                $opencodeInstallMethod = "Chocolatey"
            } else {
                Start-Process "https://opencode.ai"
                Print-Info "Download OpenCode from the page that just opened."
                if (-not (Wait-ForCheck "OpenCode" { Is-Installed "opencode" })) {
                    Print-Info "Stopping here for now. Run .\scripts\setup.ps1 again when you're ready."
                    exit 0
                }
                $opencodeInstallMethod = "manual installer"
            }

            if (-not (Is-Installed "opencode")) {
                Print-Warn "OpenCode setup did not finish yet."
                Print-Info "We'll stop here so you can pick back up at OpenCode next time."
                Print-Info "Your local checkpoint is saved at:"
                Print-Info "  $global:PROGRESS_FILE"
                exit 0
            }

            $opencodeConfigDir = "$env:APPDATA\opencode"
            $opencodeConfigPath = "$opencodeConfigDir\config.json"
            New-Item -ItemType Directory -Path $opencodeConfigDir -Force | Out-Null

            if (Test-Path $opencodeConfigPath) {
                Print-Info "An OpenCode config already exists at $opencodeConfigPath"
                $choice = Ask-Choice "What would you like to do with the existing config?" @(
                    "Keep the existing config unchanged",
                    "Replace it with the default Ollama config for this repo"
                )

                if ($choice -eq 2) {
                    Backup-FileIfExists $opencodeConfigPath "OpenCode config"
                    $opencodeConfig = @{
                        '$schema' = "https://opencode.ai/config.json"
                        provider = @{
                            ollama = @{
                                npm = "@ai-sdk/openai-compatible"
                                name = "Ollama (local)"
                                options = @{
                                    baseURL = "http://localhost:11434/v1"
                                }
                                models = @{
                                    $global:LOCAL_MODEL = @{
                                        name = "$($global:LOCAL_MODEL) (local)"
                                    }
                                }
                            }
                        }
                        model = "ollama/$($global:LOCAL_MODEL)"
                    } | ConvertTo-Json -Depth 6
                    Set-Content -Path $opencodeConfigPath -Value $opencodeConfig
                    Print-Success "OpenCode configured to use $global:LOCAL_MODEL via Ollama."
                    $opencodeConfigStatus = "OpenCode is configured to use $global:LOCAL_MODEL via Ollama."
                }
            } else {
                $opencodeConfig = @{
                    '$schema' = "https://opencode.ai/config.json"
                    provider = @{
                        ollama = @{
                            npm = "@ai-sdk/openai-compatible"
                            name = "Ollama (local)"
                            options = @{
                                baseURL = "http://localhost:11434/v1"
                            }
                            models = @{
                                $global:LOCAL_MODEL = @{
                                    name = "$($global:LOCAL_MODEL) (local)"
                                }
                            }
                        }
                    }
                    model = "ollama/$($global:LOCAL_MODEL)"
                } | ConvertTo-Json -Depth 6
                Set-Content -Path $opencodeConfigPath -Value $opencodeConfig
                Print-Success "OpenCode configured to use $global:LOCAL_MODEL via Ollama."
                $opencodeConfigStatus = "OpenCode is configured to use $global:LOCAL_MODEL via Ollama."
            }

            Print-Info $opencodeConfigStatus
            Write-StateRecord "OpenCode" "installed" $opencodeInstallMethod "$env:APPDATA\opencode\" "CLI"
        }
    }

    Mark-SetupStepComplete "opencode" "vscode"
    $nextStep = "vscode"
}

if ($nextStep -eq "vscode") {
    Mark-SetupStepStarted "vscode"

    if (Ask-YesNo "Set up VS Code (IDE surface)?") {
        if (-not (Is-Installed "ollama")) {
            Print-Warn "VS Code AI setup needs Ollama first."
            Print-Info "Install Ollama in Step 2, then run this script again so Continue can use your local model."
            Print-Info "We'll stop here so you can pick back up at VS Code next time."
            Print-Info "Your local checkpoint is saved at:"
            Print-Info "  $global:PROGRESS_FILE"
            exit 0
        } else {
            Print-Header "Installing VS Code"
            $vsCodeInstallMethod = "existing"
            $continueExtensionStatus = "Continue extension still needs to be installed."
            $continueConfigStatus = "Continue config left unchanged."

            if (Test-VSCodeInstalled) {
                $codeVersion = Get-ToolVersion "code"
                if ($codeVersion) {
                    Print-Success "VS Code is already installed  ($codeVersion)"
                } else {
                    Print-Success "VS Code is already installed."
                }
            } elseif (Is-Installed "choco") {
                Run-WithStatus "Installing VS Code" { choco install vscode -y }
                $env:Path = [System.Environment]::GetEnvironmentVariable("Path", "Machine") + ";" + [System.Environment]::GetEnvironmentVariable("Path", "User")
                Print-Success "VS Code installed."
                $vsCodeInstallMethod = "Chocolatey"
            } else {
                Start-Process "https://code.visualstudio.com/download"
                Print-Info "Download VS Code from the page that just opened."
                Print-Info "During install, check 'Add to PATH' when prompted."
                if (-not (Wait-ForCheck "VS Code" { Test-VSCodeInstalled })) {
                    Print-Info "Stopping here for now. Run .\scripts\setup.ps1 again when you're ready."
                    exit 0
                }
                $vsCodeInstallMethod = "manual installer"
            }

            if (-not (Test-VSCodeInstalled)) {
                Print-Warn "VS Code setup did not finish yet."
                Print-Info "We'll stop here so you can pick back up at VS Code next time."
                Print-Info "Your local checkpoint is saved at:"
                Print-Info "  $global:PROGRESS_FILE"
                exit 0
            }

            if (Is-Installed "code") {
                Print-Step "Installing the Continue extension..."
                Run-WithStatus "Installing the Continue extension" { code --install-extension continue.continue --force }
                Print-Success "Continue extension installed."
                $continueExtensionStatus = "Continue extension is installed."

                $continueConfigDir = "$env:USERPROFILE\.continue"
                $continueConfigPath = "$continueConfigDir\config.json"
                New-Item -ItemType Directory -Path $continueConfigDir -Force | Out-Null

                if (Test-Path $continueConfigPath) {
                    Print-Info "A Continue config already exists at $continueConfigPath"
                    $choice = Ask-Choice "What would you like to do with the existing config?" @(
                        "Keep the existing config unchanged",
                        "Replace it with the default Ollama config for this repo"
                    )

                    if ($choice -eq 2) {
                        Backup-FileIfExists $continueConfigPath "Continue config"
                        $continueConfig = @{
                            models = @(@{
                                title = "$($global:LOCAL_MODEL) (local)"
                                provider = "ollama"
                                model = $global:LOCAL_MODEL
                            })
                            tabAutocompleteModel = @{
                                title = "$($global:LOCAL_MODEL) (local)"
                                provider = "ollama"
                                model = $global:LOCAL_MODEL
                            }
                        } | ConvertTo-Json -Depth 5
                        Set-Content -Path $continueConfigPath -Value $continueConfig
                        Print-Success "Continue configured to use $global:LOCAL_MODEL via Ollama."
                        $continueConfigStatus = "Continue is configured to use $global:LOCAL_MODEL via Ollama."
                    }
                } else {
                    $continueConfig = @{
                        models = @(@{
                            title = "$($global:LOCAL_MODEL) (local)"
                            provider = "ollama"
                            model = $global:LOCAL_MODEL
                        })
                        tabAutocompleteModel = @{
                            title = "$($global:LOCAL_MODEL) (local)"
                            provider = "ollama"
                            model = $global:LOCAL_MODEL
                        }
                    } | ConvertTo-Json -Depth 5
                    Set-Content -Path $continueConfigPath -Value $continueConfig
                    Print-Success "Continue configured to use $global:LOCAL_MODEL via Ollama."
                    $continueConfigStatus = "Continue is configured to use $global:LOCAL_MODEL via Ollama."
                }
            } else {
                Print-Warn "VS Code is installed, but the 'code' command is not available yet."
                Print-Info "We'll stop here so you can pick back up at VS Code next time."
                Print-Info "Restart PowerShell after installation. If it still isn't available:"
                Print-Info "  1. Open VS Code"
                Print-Info "  2. Open the Command Palette"
                Print-Info "  3. Search for: Shell Command: Install 'code' command in PATH"
                Print-Info "  4. Reopen PowerShell"
                Print-Info "Then install the Continue extension manually:"
                Print-Info "  Open VS Code > Extensions (Ctrl+Shift+X) > search 'Continue' > Install"
                Print-Info "Your local checkpoint is saved at:"
                Print-Info "  $global:PROGRESS_FILE"
                exit 0
            }

            Print-Info $continueExtensionStatus
            Print-Info $continueConfigStatus
            $vsCodeRecordedVersion = Get-ToolVersion "code"
            if (-not $vsCodeRecordedVersion) {
                $vsCodeRecordedVersion = "installed"
            }
            Write-StateRecord "VS Code" $vsCodeRecordedVersion $vsCodeInstallMethod "$env:APPDATA\Code\User\settings.json" "IDE"
        }
    }

    Mark-SetupStepComplete "vscode" "paid_models"
    $nextStep = "paid_models"
}

# ---------------------------------------------------------------------------
# Step 4 — Paid models (optional)
# ---------------------------------------------------------------------------
if ($nextStep -eq "paid_models") {
    Mark-SetupStepStarted "paid_models"

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

    Mark-SetupStepComplete "paid_models" "package_manager"
}

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
Clear-SetupProgress
