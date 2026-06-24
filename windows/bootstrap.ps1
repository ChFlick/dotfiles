<#
.SYNOPSIS
    Bootstrap a Windows dev environment from this dotfiles repo.

.DESCRIPTION
    - Installs core CLI tools via winget.
    - Installs PowerShell helper modules.
    - Links (or copies) the shared config files into their real locations:
        * PowerShell profile      -> $PROFILE
        * Starship config         -> %LOCALAPPDATA%\starship\starship.toml
        * Git config              -> ~\.gitconfig
        * Neovim config           -> %LOCALAPPDATA%\nvim
    - Seeds local-only override files from their templates (never overwrites).

    Idempotent: re-running is safe. Existing real files are backed up to
    "<file>.bak-<timestamp>" before being replaced.

.PARAMETER NoInstall
    Skip the winget / module installation step (only (re)link config).

.PARAMETER Copy
    Copy files instead of symlinking (use when Developer Mode / admin is
    unavailable). Symlinks are preferred so edits flow back to the repo.

.PARAMETER WithLlmAssets
    Also clone (if missing) and set up the companion `llm-assets` repo —
    GitHub Copilot CLI agents/hooks/skills/knowledge base.

.EXAMPLE
    pwsh -File windows\bootstrap.ps1
#>
[CmdletBinding()]
param(
    [switch]$NoInstall,
    [switch]$Copy,
    [switch]$WithLlmAssets
)

$ErrorActionPreference = 'Stop'
$RepoRoot   = Split-Path $PSScriptRoot -Parent
$WindowsDir = $PSScriptRoot
$Stamp      = Get-Date -Format 'yyyyMMdd-HHmmss'

function Write-Step($msg) { Write-Host "==> $msg" -ForegroundColor Cyan }
function Write-Ok($msg)   { Write-Host "    $msg" -ForegroundColor Green }
function Write-Skip($msg) { Write-Host "    $msg" -ForegroundColor DarkGray }

# ---------------------------------------------------------------------------
# 1. Install tools
# ---------------------------------------------------------------------------
function Install-WingetPackages {
    if (-not (Get-Command winget -ErrorAction SilentlyContinue)) {
        Write-Warning "winget not found; skipping tool installation."
        return
    }
    $packages = @(
        'Neovim.Neovim'
        'sharkdp.bat'
        'sharkdp.fd'
        'dandavison.delta'
        'junegunn.fzf'
        'ajeetdsouza.zoxide'
        'eza-community.eza'
        'Starship.Starship'
        'GitHub.cli'
        'BurntSushi.ripgrep.MSVC'
        'Wilfred.difftastic'
    )
    foreach ($id in $packages) {
        $installed = winget list --id $id -e --source winget 2>$null |
            Select-String -SimpleMatch $id
        if ($installed) {
            Write-Skip "$id already installed"
            continue
        }
        Write-Step "Installing $id"
        winget install --id $id -e --source winget `
            --accept-package-agreements --accept-source-agreements --silent
    }
}

function Install-PSModules {
    $modules = 'Terminal-Icons', 'posh-git', 'PSFzf'
    foreach ($m in $modules) {
        if (Get-Module -ListAvailable $m) {
            Write-Skip "$m already installed"
            continue
        }
        Write-Step "Installing PowerShell module $m"
        Install-Module $m -Scope CurrentUser -Force -AcceptLicense -ErrorAction Continue
    }
}

# ---------------------------------------------------------------------------
# 2. Link / copy helpers
# ---------------------------------------------------------------------------
function Link-Item {
    param(
        [Parameter(Mandatory)] [string]$Source,
        [Parameter(Mandatory)] [string]$Target
    )
    if (-not (Test-Path $Source)) {
        Write-Warning "Source missing, skipping: $Source"
        return
    }

    $parent = Split-Path $Target -Parent
    if ($parent -and -not (Test-Path $parent)) {
        New-Item -ItemType Directory -Force -Path $parent | Out-Null
    }

    # Already linked to the right place?
    $existing = Get-Item $Target -ErrorAction SilentlyContinue
    if ($existing -and $existing.LinkType -eq 'SymbolicLink' -and
        $existing.Target -and ((Resolve-Path $existing.Target -ErrorAction SilentlyContinue).Path -eq (Resolve-Path $Source).Path)) {
        Write-Skip "Already linked: $Target"
        return
    }

    if (Test-Path $Target) {
        $backup = "$Target.bak-$Stamp"
        Write-Step "Backing up existing $Target -> $backup"
        Move-Item -LiteralPath $Target -Destination $backup -Force
    }

    if ($Copy) {
        Copy-Item $Source $Target -Recurse -Force
        Write-Ok "Copied -> $Target"
    } else {
        try {
            New-Item -ItemType SymbolicLink -Path $Target -Target $Source -Force | Out-Null
            Write-Ok "Linked -> $Target"
        } catch {
            Write-Warning "Symlink failed (need Developer Mode/admin?); copying instead."
            Copy-Item $Source $Target -Recurse -Force
            Write-Ok "Copied -> $Target"
        }
    }
}

function Seed-FromTemplate {
    param(
        [Parameter(Mandatory)] [string]$Template,
        [Parameter(Mandatory)] [string]$Target
    )
    if (Test-Path $Target) { Write-Skip "Local file exists, leaving as-is: $Target"; return }
    if (-not (Test-Path $Template)) { Write-Warning "Template missing: $Template"; return }
    $parent = Split-Path $Target -Parent
    if ($parent -and -not (Test-Path $parent)) { New-Item -ItemType Directory -Force -Path $parent | Out-Null }
    Copy-Item $Template $Target
    Write-Ok "Seeded $Target (edit it with your details)"
}

function Setup-LlmAssets {
    $dest = Join-Path $HOME 'dev\llm-assets'
    if (-not (Test-Path $dest)) {
        Write-Step "Cloning llm-assets"
        git clone https://github.com/ChFlick/llm-assets.git $dest
    } else {
        Write-Skip "llm-assets already cloned: $dest"
    }
    $setup = Join-Path $dest 'setup.ps1'
    if (Test-Path $setup) {
        Write-Step "Running llm-assets setup.ps1"
        & $setup
    } else {
        Write-Warning "llm-assets setup.ps1 not found at $setup"
    }
}

# ---------------------------------------------------------------------------
# 3. Run
# ---------------------------------------------------------------------------
if (-not $NoInstall) {
    Write-Step "Installing tools"
    Install-WingetPackages
    Install-PSModules
}

Write-Step "Linking configuration"

# PowerShell profile + colearn instructions (must sit next to the profile)
$profileDir = Split-Path $PROFILE -Parent
Link-Item (Join-Path $WindowsDir 'Microsoft.PowerShell_profile.ps1') $PROFILE
Link-Item (Join-Path $WindowsDir 'colearn-instructions.md') (Join-Path $profileDir 'colearn-instructions.md')

# Starship
Link-Item (Join-Path $WindowsDir 'starship.toml') (Join-Path $env:LOCALAPPDATA 'starship\starship.toml')

# Git
Link-Item (Join-Path $WindowsDir 'gitconfig') (Join-Path $HOME '.gitconfig')

# Neovim (canonical config shared with macOS/Linux lives in .config/nvim)
Link-Item (Join-Path $RepoRoot '.config\nvim') (Join-Path $env:LOCALAPPDATA 'nvim')

Write-Step "Seeding local override files"
Seed-FromTemplate (Join-Path $WindowsDir 'profile.local.ps1.template')          (Join-Path $HOME '.config\powershell\profile.local.ps1')
Seed-FromTemplate (Join-Path $WindowsDir 'gitconfig.local.template')            (Join-Path $HOME '.gitconfig.local')
Seed-FromTemplate (Join-Path $WindowsDir 'gitconfig.local.private.template')    (Join-Path $HOME '.gitconfig.local.private')

Write-Host ""
if ($WithLlmAssets) {
    Write-Step "Setting up companion llm-assets repo"
    try { Setup-LlmAssets } catch { Write-Warning "llm-assets setup failed: $($_.Exception.Message)" }
}

Write-Ok "Done. Restart your shell (or run: . `$PROFILE) to load the new profile."
