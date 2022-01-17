alias vi nvim
alias vim nvim

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
alias cursebreaker '/bin/bash -c "/mnt/48680A47680A33EA/Program\ Files\ \(x86\)/World\ of\ Warcraft/_retail_/CurseBreaker-linux"'
alias owf aiksaurus
alias cat bat
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
alias whoowns "pacman -Qo"
alias whocontains "pacman -F"

thefuck --alias | source

alias gnomeRestartPls "dbus-send --type=method_call --print-reply  --dest=org.gnome.Shell /org/gnome/Shell org.gnome.Shell.Eval string:'global.reexec_self()'"

alias dropdownKitty "tdrop -ma -w 80% -x 10% kitty"

# Notes
alias notes "git -C $HOME/Documents/notes"
alias notessync "notes pull && notes push"
alias notescommit "notes add : && notes commit -m \"Update notes\" && notes push" 

alias dotfiles "/usr/bin/git --git-dir=$HOME/.dotfiles/ --work-tree=$HOME"
alias dof dotfiles
alias dofcommit "dof add --update && dof commit -m \"Update dotfiles\" && dof push"

alias ls exa

# Random stuff
alias dwarfs /opt/linux-dwarf-pack/AppRun
