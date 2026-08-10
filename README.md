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
| Package list | `.Brewfile` (installed by `yadm bootstrap` via `brew bundle --global`) |

Tools assumed on the PATH: `nvim`, `eza`, `bat`, `delta`, `difft`, `fzf`,
`zoxide`, `fd`, `ripgrep`, `starship`, `gh`. On macOS/Linux these all come from
`.Brewfile`; on Windows the bootstrap installs them via winget/scoop.

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

`yadm bootstrap` is idempotent and takes care of the rest: submodules
(powerlevel10k, git-toolbelt, ranger_devicons), `brew bundle --global` from
`.Brewfile`, the goku service, the npm prefix, lazy.nvim plugin restore from the
committed `lazy-lock.json`, fisher plugins, and seeding the local override
files below.

Two things it can't do for you:

- **SSH key** — `.config/yadm/config` pushes with `~/.ssh/id_github_chflick`.
  Create it and add the public half to GitHub:

  ```sh
  ssh-keygen -t ed25519 -f ~/.ssh/id_github_chflick
  gh ssh-key add ~/.ssh/id_github_chflick.pub
  ```

- **Login shell** — pick one: `chsh -s "$(command -v fish)"` (or `zsh`).

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
seeded by `yadm bootstrap` (macOS/Linux) or `windows\bootstrap.ps1`, and are
listed in `.gitignore`:

- `~/.gitconfig.local` — your name/email
- `~/.gitconfig.local.private` — per-area credentials (e.g. Azure DevOps)
- `~/.config/powershell/profile.local.ps1` — machine/work-specific PowerShell
- `~/.zshrc.local` — machine/work-specific zsh
- `~/.config/fish/config.local.fish` — machine/work-specific fish

## Related repositories

- **[llm-assets](https://github.com/ChFlick/llm-assets)** (private) — GitHub
  Copilot CLI assets: custom agents, hooks, skills, knowledge base, and
  instructions. It has its own `setup.ps1` that junction-links those folders into
  `~/.copilot`. Kept separate (different access/lifecycle).

  **Windows** can pull it in via the bootstrap:

  ```powershell
  pwsh -File windows\bootstrap.ps1 -WithLlmAssets
  ```

  **macOS / Linux:**

  ```sh
  git clone git@ghprivate:ChFlick/llm-assets.git ~/dev/llm-assets
  cd ~/dev/llm-assets && ./setup.sh
  ```

  `setup.sh` detects macOS/Linux/WSL, installs Rust + `rtk`, and symlinks
  `agents/`, `hooks/`, `skills/`, `knowledgebase/` and `copilot-instructions.md`
  into `~/.copilot`.

## Editing shortcuts

`ea` aliases, `ec` shell config, `ep` profile, `eg` gitconfig, `ev` editor config.

### Credits

Credits to https://github.dev/phelipetls/dotfiles where I peeked a bit for the
ansible setup.
