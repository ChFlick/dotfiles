# ============================================================================
#  PowerShell profile (shared, version-controlled via dotfiles)
#  Linked into $PROFILE by windows/bootstrap.ps1
#  Edit with:  ec     (machine/work-specific overrides go in profile.local.ps1: el)
# ============================================================================

# --- Local-only overrides (machine/work specific, NOT committed) -------------
$localProfile = "$HOME\.config\powershell\profile.local.ps1"
if (Test-Path $localProfile) { . $localProfile }

# --- Azure CLI tab completion (only if az is installed) ----------------------
if (Get-Command az -ErrorAction SilentlyContinue) {
    Register-ArgumentCompleter -Native -CommandName az -ScriptBlock {
        param($commandName, $wordToComplete, $cursorPosition)
        $completion_file = New-TemporaryFile
        $env:ARGCOMPLETE_USE_TEMPFILES = 1
        $env:_ARGCOMPLETE_STDOUT_FILENAME = $completion_file
        $env:COMP_LINE = $wordToComplete
        $env:COMP_POINT = $cursorPosition
        $env:_ARGCOMPLETE = 1
        $env:_ARGCOMPLETE_SUPPRESS_SPACE = 0
        $env:_ARGCOMPLETE_IFS = "`n"
        $env:_ARGCOMPLETE_SHELL = 'powershell'
        az 2>&1 | Out-Null
        Get-Content $completion_file | Sort-Object | ForEach-Object {
            [System.Management.Automation.CompletionResult]::new($_, $_, "ParameterValue", $_)
        }
        Remove-Item $completion_file, Env:\_ARGCOMPLETE_STDOUT_FILENAME, Env:\ARGCOMPLETE_USE_TEMPFILES, Env:\COMP_LINE, Env:\COMP_POINT, Env:\_ARGCOMPLETE, Env:\_ARGCOMPLETE_SUPPRESS_SPACE, Env:\_ARGCOMPLETE_IFS, Env:\_ARGCOMPLETE_SHELL
    }
}

# --- PSReadLine: history search + menu completion ----------------------------
Set-PSReadLineOption -HistorySearchCursorMovesToEnd
Set-PSReadLineKeyHandler -Key UpArrow -Function HistorySearchBackward
Set-PSReadLineKeyHandler -Key DownArrow -Function HistorySearchForward
Set-PSReadlineKeyHandler -Key Tab -Function MenuComplete

# --- Icons for ls, etc. (Terminal-Icons) -------------------------------------
if (Get-Module -ListAvailable Terminal-Icons -ErrorAction SilentlyContinue) {
    Import-Module -Name Terminal-Icons
}

# --- Starship prompt (guarded — fails gracefully under AppControl) -----------
if (Get-Command starship -ErrorAction SilentlyContinue) {
    $ENV:STARSHIP_CONFIG = "$ENV:LOCALAPPDATA\starship\starship.toml"
    function Invoke-Starship-TransientFunction {
        &starship module character
    }
    try {
        $prevEAP = $ErrorActionPreference
        $ErrorActionPreference = 'Stop'
        Invoke-Expression (&starship init powershell)
        Enable-TransientPrompt
    } catch {
        # Starship unavailable (AppControl, encoding issues, etc.) — default prompt
    } finally {
        $ErrorActionPreference = $prevEAP
    }
}

#####################################################
# Aliases and functions
#

# Edit configs:  ec = this profile,  el = local overrides,  ev = neovim
function ec { nvim $PROFILE }
function el { nvim "$HOME\.config\powershell\profile.local.ps1" }
function ev { nvim "$env:LOCALAPPDATA\nvim\init.lua" }

# --- git ---------------------------------------------------------------------
function gits { git status }
Set-Alias gitp git
function gitlist {
    param ( [int]$days = 90 )
    git log --since="$days days ago" --pretty=format:"" --name-only |
        Select-String -Pattern "[^\s]" | Sort-Object | Get-Unique |
        Sort-Object -Descending | Select-Object -First 10
}
# posh-git: smarter git autocomplete
if (Get-Module -ListAvailable posh-git -ErrorAction SilentlyContinue) {
    Import-Module posh-git
}

# --- Util --------------------------------------------------------------------
Set-Alias c clear
Set-Alias vi nvim
Set-Alias vim nvim
Set-Alias touch New-Item

function lv {
    $env:NVIM_APPNAME = "lvim"
    try { nvim @args }
    finally { Remove-Item Env:\NVIM_APPNAME -ErrorAction SilentlyContinue }
}

if (Get-Command eza -ErrorAction SilentlyContinue) {
    function ezaLs { eza --icons @args }
    Set-Alias -Name ls -Value ezaLs
    function ll { eza --long --icons @args }
    function la { eza -a --icons @args }
}

# --- Notes (git-backed notes repo under ~/dev/notes) -------------------------
function notes      { git -C "$env:USERPROFILE\dev\notes" @args }
function notessync  { notes pull; notes push }
function notescommit {
    notes add :
    notes commit -m "Update notes"
    notes push
}

# --- FZF: Ctrl+e search, Ctrl+r reverse history ------------------------------
if (Get-Command fzf -ErrorAction SilentlyContinue) {
    if (Get-Module -ListAvailable PSFzf -ErrorAction SilentlyContinue) {
        Import-Module PSFzf
        Set-PsFzfOption -PSReadlineChordProvider 'Ctrl+e' -PSReadlineChordReverseHistory 'Ctrl+r'
    }
}

# --- zoxide: z <location>; smart cd ------------------------------------------
if (Get-Command zoxide -ErrorAction SilentlyContinue) {
    Invoke-Expression (& { (zoxide init powershell | Out-String) })
}

# --- Copilot helpers ---------------------------------------------------------
# cotemp: run Copilot CLI in a throwaway temp directory
function Invoke-CopilotTmp {
    $tmp = New-Item -ItemType Directory -Path (Join-Path $env:TEMP "copilot-$(Get-Random)")
    $prev = $PWD
    Set-Location $tmp
    try {
        copilot
    } finally {
        Set-Location $prev
        Remove-Item $tmp -Recurse -Force -ErrorAction SilentlyContinue
    }
}
Set-Alias cotemp Invoke-CopilotTmp

# colearn: Copilot CLI in "Socratic tutor" learn mode (throwaway repo)
function colearn {
    $originalDir = Get-Location
    $tmpDir = Join-Path ([System.IO.Path]::GetTempPath()) "colearn-$(Get-Random)"
    New-Item -ItemType Directory -Path $tmpDir -Force | Out-Null
    $githubDir = Join-Path $tmpDir ".github"
    New-Item -ItemType Directory -Path $githubDir -Force | Out-Null

    $instructionsPath = Join-Path $PSScriptRoot "colearn-instructions.md"
    if (Test-Path $instructionsPath) {
        Copy-Item $instructionsPath (Join-Path $githubDir "copilot-instructions.md")
    } else {
        Set-Content -Path (Join-Path $githubDir "copilot-instructions.md") `
            -Value "# Socratic Tutor`nGuide me toward insight with one question at a time; don't give the answer unless I ask." `
            -Encoding UTF8
    }

    Set-Location $tmpDir
    try {
        Write-Host "Starting Copilot Learn Mode..." -ForegroundColor Cyan
        copilot
    }
    finally {
        Set-Location $originalDir
        Remove-Item -Path $tmpDir -Recurse -Force -ErrorAction SilentlyContinue
        Write-Host "Learn mode session cleaned up." -ForegroundColor DarkGray
    }
}

# coquiz: Copilot CLI in "examiner" test-my-knowledge mode (throwaway repo).
# Tests how well you know a topic with application-focused questions.
#   coquiz                              -> asks what to test
#   coquiz "raft consensus"             -> pre-seeds the scope (positional)
#   coquiz --scope "raft consensus"     -> same, via flag
#   coquiz --scope "DDIA ch.5" --material .\ch5.pdf -> grounds questions in a file/folder
function coquiz {
    # Accepts Linux-style flags (--scope/--material, -s/-m) or positional args:
    #   coquiz "raft consensus"
    #   coquiz --scope "raft consensus" --material .\ch5.pdf
    $Scope = $null
    $Material = $null
    $positional = @()
    for ($i = 0; $i -lt $args.Count; $i++) {
        switch -Regex ($args[$i]) {
            '^(--scope|-s)$'    { $i++; $Scope = $args[$i] }
            '^(--material|-m)$' { $i++; $Material = $args[$i] }
            '^--scope=(.*)$'    { $Scope = $Matches[1] }
            '^--material=(.*)$' { $Material = $Matches[1] }
            default             { $positional += $args[$i] }
        }
    }
    if (-not $Scope -and $positional.Count -ge 1)    { $Scope = $positional[0] }
    if (-not $Material -and $positional.Count -ge 2) { $Material = $positional[1] }

    $originalDir = Get-Location
    $tmpDir = Join-Path ([System.IO.Path]::GetTempPath()) "coquiz-$(Get-Random)"
    New-Item -ItemType Directory -Path $tmpDir -Force | Out-Null
    $githubDir = Join-Path $tmpDir ".github"
    New-Item -ItemType Directory -Path $githubDir -Force | Out-Null

    $instructionsPath = Join-Path $PSScriptRoot "coquiz-instructions.md"
    if (Test-Path $instructionsPath) {
        Copy-Item $instructionsPath (Join-Path $githubDir "copilot-instructions.md")
    } else {
        Set-Content -Path (Join-Path $githubDir "copilot-instructions.md") `
            -Value "# Examiner`nTest how well I know a topic. Ask one application-focused question at a time (apply, counterfactual, trade-offs, find-the-flaw, teach-back), assess each answer honestly, reveal correct answers, and give an end-of-session report. Rigorous but encouraging." `
            -Encoding UTF8
    }

    # Optionally copy source material into the session so Copilot can read it.
    $materialNote = ""
    if ($Material) {
        if (Test-Path $Material) {
            $materialDir = Join-Path $tmpDir "material"
            New-Item -ItemType Directory -Path $materialDir -Force | Out-Null
            Copy-Item -Path $Material -Destination $materialDir -Recurse -Force
            $materialNote = " Source material is in the ``material/`` folder — read it first and anchor your questions to it."
        } else {
            Write-Host "coquiz: material path not found: $Material" -ForegroundColor Yellow
        }
    }

    Set-Location $tmpDir
    try {
        Write-Host "Starting Copilot Quiz Mode..." -ForegroundColor Cyan
        if ($Scope) { Write-Host "Scope: $Scope" -ForegroundColor DarkGray }
        # Pre-seed the scope as the opening message when given; otherwise the
        # examiner asks what to test.
        if ($Scope -or $materialNote) {
            $seed = if ($Scope) { "Test my knowledge of: $Scope.$materialNote" } else { "Test my knowledge.$materialNote" }
            copilot -i $seed
        } else {
            copilot
        }
    }
    finally {
        Set-Location $originalDir
        Remove-Item -Path $tmpDir -Recurse -Force -ErrorAction SilentlyContinue
        Write-Host "Quiz mode session cleaned up." -ForegroundColor DarkGray
    }
}
