. ~/.config/fish/aliases.fish
. ~/.config/fish/config.local.fish

set fish_greeting ''
set -gx QT_STYLE_OVERRIDE 'kvantum'

set -gx MAKEFLAGS '-j8'
set -gx NVM_DIR /usr/share/nvm

function nvm
   bass source /usr/share/nvm/nvm.sh --no-use ';' nvm $argv
end

set -x NVM_DIR ~/.nvm
set -x CHROME_EXECUTABLE /usr/bin/chromium
nvm use default --silent

set -gx VISUAL nvim
set -gx EDITOR nvim

# fzf
####
set -g FZF_DEFAULT_OPTS '--height 50% --layout=reverse --border --inline-info --preview "bat --color \"always\" {}" --bind="ctrl-o:execute(code {})+abort"'
set -g FZF_DEFAULT_COMMAND 'fd . "$dir" --type f -L -E ~/Games -E .git -E node_modules '
set -g FZF_CTRL_T_COMMAND $FZF_DEFAULT_COMMAND 
set -g FZF_ALT_C_COMMAND 'fd . "$dir" --type d -E ~/Games -E .git -E node_modules'
set -g FZF_ALT_C_OPTS '--preview "tree -C {} | head -100"'

