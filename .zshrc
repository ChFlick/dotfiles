# Enable Powerlevel10k instant prompt. Should stay close to the top of ~/.zshrc.
# Initialization code that may require console input (password prompts, [y/n]
# confirmations, etc.) must go above this block; everything else may go below.
if [[ -r "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh" ]]; then
  source "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh"
fi

. "$HOME/.cargo/env"

# General Environment & Path Variables
export PATH="$VOLTA_HOME/bin:$PATH"
export PATH="$(brew --prefix)/bin:$PATH"
export VOLTA_HOME="$HOME/.volta"
export TOAST_GIT="$HOME/toast/git-repos"
export RIPGREP_CONFIG_PATH="$HOME/.ripgreprc"

# GPG Config
export GPG_TTY=$(tty)
gpgconf --launch gpg-agent

# Set VISUAL and EDITOR to nvim
export VISUAL=nvim
export EDITOR=nvim

# FZF Config
[ -f ~/.fzf.zsh ] && source ~/.fzf.zsh
export FZF_DEFAULT_OPTS='--height 50% --layout=reverse --border --inline-info --preview "bat --color \"always\" {}" --bind="ctrl-o:execute(code {})+abort"'
export FZF_DEFAULT_COMMAND='fd . "$dir" --type f -L -E .git -E node_modules '
export FZF_CTRL_T_COMMAND="$FZF_DEFAULT_COMMAND"
export FZF_ALT_C_COMMAND='fd . "$dir" --type d -E .git -E node_modules'
export FZF_ALT_C_OPTS='--preview "tree -C {} | head -100"'

# Brew autocompletion
if type brew &>/dev/null
then
  FPATH="$(brew --prefix)/share/zsh/site-functions:${FPATH}"

  autoload -Uz compinit
  compinit
fi

# enable zsh-autosuggestions
source $(brew --prefix)/share/zsh-autosuggestions/zsh-autosuggestions.zsh
source $(brew --prefix)/share/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh
source $(brew --prefix)/share/zsh-history-substring-search/zsh-history-substring-search.zsh

source ~/.aliases
source ~/.profile

# p10k zsh prompt. To customize prompt, run `p10k configure` or edit ~/.p10k.zsh.
source ~/powerlevel10k/powerlevel10k.zsh-theme
[[ ! -f ~/.p10k.zsh ]] || source ~/.p10k.zsh
