. ~/.config/fish/aliases.fish
. ~/.config/fish/config.local.fish

set -gx MAKEFLAGS '-j8'
set -gx NVM_DIR /usr/share/nvm
#set -U fish_user_paths (ruby -e 'print Gem.user_dir')/bin $fish_user_paths

function nvm
   bass source /usr/share/nvm/nvm.sh --no-use ';' nvm $argv
end

set -x NVM_DIR ~/.nvm
nvm use default --silent

set -gx VISUAL vim


# fzf
####
set -g FZF_DEFAULT_OPTS '--height 50% --layout=reverse --border --inline-info --preview "bat --color \"always\" {}"'
set -g FZF_DEFAULT_COMMAND 'fd . "$dir" --type f -L -E ~/Games -E .git -E node_modules '
set -g FZF_CTRL_T_COMMAND $FZF_DEFAULT_COMMAND 
set -g FZF_ALT_C_COMMAND 'fd . "$dir" --type d -E ~/Games -E .git -E node_modules'
set -g FZF_ALT_C_OPTS '--preview "tree -C {} | head -100"'

function _fzf_compgen_path
  fd --hidden --follow --exclude ".git" . "$1"
end

# Use fd to generate the list for directory completion
function _fzf_compgen_dir
  fd --type d --hidden --follow --exclude ".git" . "$1"
end
