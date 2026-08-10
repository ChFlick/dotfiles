# ~/.Brewfile — installed by `yadm bootstrap` via `brew bundle --global`.
#
# Everything the committed configs actually reference. Re-runnable: brew skips
# anything already installed.
#
#   brew bundle --global          # install
#   brew bundle --global --cleanup --dry-run   # show extras not listed here

tap "yqrashawn/goku"

# --- Core ------------------------------------------------------------------
brew "git"
brew "yadm"                # dotfile manager (this repo)
brew "gh"                  # GitHub CLI
brew "gnupg"               # config.fish launches gpg-agent

# --- Shells & prompt -------------------------------------------------------
brew "zsh"
brew "fish"
brew "starship"            # prompt (fish/zsh); p10k comes from the submodule

# --- Editor ----------------------------------------------------------------
brew "neovim"              # .config/nvim (lazy.nvim)

# --- CLI tools referenced by .aliases / .gitconfig / config.fish -----------
brew "eza"                 # alias ls/la/ll
brew "bat"                 # alias cat, fzf preview
brew "fd"                  # FZF_DEFAULT_COMMAND
brew "ripgrep"             # RIPGREP_CONFIG_PATH -> ~/.ripgreprc
brew "fzf"
brew "zoxide"
brew "git-delta"           # .gitconfig core.pager / interactive.diffFilter
brew "difftastic"          # .gitconfig diff.external = difft
brew "ranger"              # .config/ranger
brew "tree"                # FZF_ALT_C_OPTS preview
brew "jq"

# --- Runtimes --------------------------------------------------------------
brew "node"

# --- Containers (config.fish points DOCKER_HOST at colima) -----------------
brew "colima"
brew "docker"
brew "docker-compose"

# --- macOS keyboard/mouse remapping ---------------------------------------
brew "yqrashawn/goku/goku" # compiles .config/karabiner.edn -> karabiner.json

cask "karabiner-elements"  # required by goku
cask "linearmouse"         # .config/linearmouse
cask "kitty"               # .config/kitty
cask "iterm2"              # .config/iterm2 colour scheme
