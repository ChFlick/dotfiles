set -gx NVM_DIR /usr/share/nvm
#set -U fish_user_paths (ruby -e 'print Gem.user_dir')/bin $fish_user_paths

function nvm
   bass source /usr/share/nvm/nvm.sh --no-use ';' nvm $argv
end

set -x NVM_DIR ~/.nvm
nvm use default --silent

set -x PATH $HOME/.rbenv/bin $PATH
rbenv init - | source
