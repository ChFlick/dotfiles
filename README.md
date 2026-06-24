# dotfiles

My configuration files for **macOS, Linux, and Windows**.

- **macOS / Linux** — managed with [yadm](https://yadm.io/); shells: zsh
  (powerlevel10k) and fish; editor: Neovim.
- **Windows** — PowerShell 7 + a standalone bootstrap script. See
  [`windows/README.md`](windows/README.md).

## What's included

| Area | Files |
|---|---|
| Shell (zsh) | `.zshrc`, `.profile`, `.aliases` |
| Shell (fish) | `.config/fish/` |
| Shell (PowerShell) | `windows/Microsoft.PowerShell_profile.ps1` |
| Editor | `.config/nvim/` (Neovim, lazy.nvim — shared across all OSes), `.vimrc` |
| Prompt | starship (`windows/starship.toml`), powerlevel10k (submodule) |
| Git | `.gitconfig` (+ `windows/gitconfig`), `.gitattributes`, `.ripgreprc` |
| Terminal / tools | `.config/kitty/`, `.config/ranger/`, `.config/iterm2/` |
| macOS-only | `.config/karabiner.edn`, `.config/linearmouse/` |

Tools assumed on the PATH: `nvim`, `eza`, `bat`, `delta`, `difft`, `fzf`,
`zoxide`, `fd`, `ripgrep`, `starship`, `gh`.

## Install

### macOS

Install XCode Command Line Tools, Brew, yadm, then pull the dotfiles:

```sh
xcode-select --install
/bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
brew install yadm
yadm clone https://github.com/chflick/dotfiles.git
yadm bootstrap
```

### Linux

Install `yadm` and `git` with your distro's package manager, then:

```sh
yadm clone https://github.com/chflick/dotfiles.git
yadm submodule update --init --recursive
yadm bootstrap
```

### Windows

PowerShell 7, then:

```powershell
git clone https://github.com/ChFlick/dotfiles.git $HOME\dev\dotfiles
cd $HOME\dev\dotfiles
pwsh -File windows\bootstrap.ps1
```

Full details (what it installs, how linking works, local overrides) are in
[`windows/README.md`](windows/README.md).

## Local / private overrides

Identity and secrets are **never committed**. They live in local files that are
seeded from `*.template` and listed in `.gitignore`:

- `~/.gitconfig.local` — your name/email
- `~/.gitconfig.local.private` — per-area credentials (e.g. Azure DevOps)
- `~/.config/powershell/profile.local.ps1` — machine/work-specific PowerShell
- `~/.zshrc.local` — machine/work-specific zsh

## Editing shortcuts

`ea` aliases, `ec` shell config, `ep` profile, `eg` gitconfig, `ev` editor config.

### Credits

Credits to https://github.dev/phelipetls/dotfiles where I peeked a bit for the
ansible setup.
