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

# git
alias gitp "git"
function gitlist --description 'Toplist of edited files in git'
    if count $argv    
        git log --since="($argv[1]) days ago" --pretty=format:"" --name-only | grep "[^\s]" | sort | uniq -c | sort -nr | head -10    
    else
        git log --since="90 days ago" --pretty=format:"" --name-only | grep "[^\s]" | sort | uniq -c | sort -nr | head -10
    end
end

# Util
alias c clear
alias vi vim
alias whoowns "pacman -Qo"
alias whocontains "pacman -F"

# Notes
alias notes "git -C $HOME/Documents/notes"
alias notepl "git -C $HOME/Documents/notes pull"
alias noteps "git -C $HOME/Documents/notes push"
alias noteup "notepl && noteps"

alias dotfiles "/usr/bin/git --git-dir=$HOME/.dotfiles/ --work-tree=$HOME"
alias dof dotfiles

