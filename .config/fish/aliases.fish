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
alias cdbuf "cd $TOAST_GIT/buffet"

## .. -> cd .. ... cd .../  etc
function multicd
    echo cd (string repeat -n (math (string length -- $argv[1]) - 1) ../)
end
abbr --add dotdot --regex '^\.\.+$' --function multicd

## !! as last item
function last_history_item; echo $history[1]; end
abbr -a !! --position anywhere --function last_history_item

# Tools
alias suf "su -l -s /bin/fish"
alias tm "gnome-system-monitor"
alias owf aiksaurus
alias cat bat

function findDesktopFiles --description 'Find the .desktop files for your Program'
    if count $argv
        grep -r "Name.*=$argv[1]" --include="*.desktop" --exclude-dir=boot,dev,proc,run,snap,sys / 2> /dev/null
    else
        echo 'Please provide a program name'
    end
end

# git
alias gits "git status"
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

alias dropdownKitty "tdrop -ma -w 80% -x 10% kitty"

# Notes
alias notes "git -C '$HOME/Resilio Sync/notes'"
alias notessync "notes pull && notes push"
alias notescommit "notes add : && notes commit -m \"Update notes\" && notes push" 

alias dof yadm
alias dofs "yadm status"
alias dofcommit "dof add --update && dof commit -m \"Update dotfiles\" && dof push"

alias ls "exa --icons"
alias la "exa -a"

## Java Versions
alias j8 "export JAVA_HOME=(/usr/libexec/java_home -v 1.8)"
alias j11 "export JAVA_HOME=(/usr/libexec/java_home -v 11)"
