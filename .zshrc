# ~/.zshrc — edited via the `ec` alias.

# Powerlevel10k instant prompt (keep near the top).
if [[ -r "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh" ]]; then
  source "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh"
fi

# History
HISTFILE=~/.zsh_history
HISTSIZE=50000
SAVEHIST=50000
setopt SHARE_HISTORY HIST_IGNORE_ALL_DUPS HIST_REDUCE_BLANKS

# Completion
autoload -Uz compinit && compinit

# Shared config
[ -f ~/.profile ] && source ~/.profile
[ -f ~/.aliases ] && source ~/.aliases

# Powerlevel10k theme (submodule)
[ -f ~/powerlevel10k/powerlevel10k.zsh-theme ] && source ~/powerlevel10k/powerlevel10k.zsh-theme
[ -f ~/.p10k.zsh ] && source ~/.p10k.zsh

# Tools (load if installed)
command -v zoxide >/dev/null 2>&1 && eval "$(zoxide init zsh)"
command -v starship >/dev/null 2>&1 && eval "$(starship init zsh)"
[ -f ~/.fzf.zsh ] && source ~/.fzf.zsh

# Local, machine-specific overrides (not committed)
[ -f ~/.zshrc.local ] && source ~/.zshrc.local
