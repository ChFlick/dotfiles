# Windows setup

PowerShell-based setup for Windows. Because `yadm` and Homebrew are
macOS/Linux-only, Windows uses a standalone `bootstrap.ps1` plus the plain
config files in this directory.

## Quick start

```powershell
git clone https://github.com/ChFlick/dotfiles.git $HOME\dev\dotfiles
cd $HOME\dev\dotfiles
pwsh -File windows\bootstrap.ps1
```

> Tip: enable **Developer Mode** (Settings → Privacy & security → For developers)
> so the script can create symlinks without admin. Otherwise pass `-Copy`.

Then restart the shell (or `. $PROFILE`).

## What the bootstrap does

1. **Installs tools via winget:** Neovim, bat, fd, delta, fzf, zoxide, eza,
   starship, GitHub CLI, ripgrep, difftastic.
2. **Installs PowerShell modules:** Terminal-Icons, posh-git, PSFzf.
3. **Links config into place** (symlink, or copy with `-Copy`):

   | Repo file | Linked to |
   |---|---|
   | `windows/Microsoft.PowerShell_profile.ps1` | `$PROFILE` |
   | `windows/colearn-instructions.md` | next to `$PROFILE` |
   | `windows/starship.toml` | `%LOCALAPPDATA%\starship\starship.toml` |
   | `windows/gitconfig` | `~\.gitconfig` |
   | `.config/nvim` | `%LOCALAPPDATA%\nvim` |

4. **Seeds local-only files** from templates (never overwrites):
   `~/.config/powershell/profile.local.ps1`, `~/.gitconfig.local`,
   `~/.gitconfig.local.private`.

## Layout

| File | Purpose |
|---|---|
| `bootstrap.ps1` | Installer + linker (idempotent, backs up existing files). |
| `Microsoft.PowerShell_profile.ps1` | Shared profile: prompt, aliases, git/eza/fzf/zoxide, Copilot helpers. |
| `profile.local.ps1.template` | Machine/work-specific overrides (copied to `~/.config/powershell/profile.local.ps1`, **not committed**). |
| `starship.toml` | Starship prompt theme. |
| `gitconfig` | Shared git config; includes the two local files below for identity/creds. |
| `gitconfig.local.template` | Your name/email (**not committed**). |
| `gitconfig.local.private.template` | Per-area credentials, e.g. Azure DevOps (**not committed**). |
| `colearn-instructions.md` | Socratic-tutor prompt used by the `colearn` function. |

## Editing config

- `ec` — edit the shared profile (`$PROFILE`)
- `el` — edit local overrides (`profile.local.ps1`)
- `ev` — edit Neovim config (`init.lua`)

Because configs are symlinked, edits land directly in the repo — commit and push
to sync to other machines.

## Re-running

`bootstrap.ps1` is safe to re-run. Use `-NoInstall` to only re-link config, or
`-Copy` to copy instead of symlink.
