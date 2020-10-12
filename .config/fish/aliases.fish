# Configs
alias ea 'vim ~/.config/fish/aliases.fish'
alias ec 'vim ~/.config/fish/config.fish'
alias eg 'vim ~/.gitconfig'
alias ev 'vim ~/.vimrc'

# Docker
alias dcu "docker-compose up"
alias dcd "docker-compose down"
alias dcs "docker-compose stop"

# Navigation
alias cd.. "cd .."
alias .. "cd .."
alias ... "cd ../.."
alias .... "cd ../../.."

# Tools
alias tm "gnome-system-monitor"

# Util
alias c clear
alias vi vim

# Notes
alias notes "git -C $HOME/Documents/notes"
alias notepl "git -C $HOME/Documents/notes pull"
alias noteps "git -C $HOME/Documents/notes push"
alias noteup "notepl && noteps"

alias dotfiles "/usr/bin/git --git-dir=$HOME/.dotfiles/ --work-tree=$HOME"
alias dof dotfiles

