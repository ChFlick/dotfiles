. ~/.config/fish/aliases.fish
test -e ~/.config/fish/config.local.fish; and . ~/.config/fish/config.local.fish

# fish_user_paths is universal, so guard against re-appending on every shell.
if test -d /opt/homebrew/bin; and not contains /opt/homebrew/bin $fish_user_paths
    set -U fish_user_paths /opt/homebrew/bin $fish_user_paths
end
set fish_greeting ''

set -x GPG_TTY (tty)
if command -v gpgconf >/dev/null
    gpgconf --launch gpg-agent
end

set -gx VISUAL nvim
set -gx EDITOR nvim
set -gx VOLTA_HOME $HOME/.volta

set PATH $HOME/.npm-packages/bin $PATH

set -x TOAST_GIT $HOME/toast/git-repos
set -x RIPGREP_CONFIG_PATH $HOME/.ripgreprc

set -x DOCKER_HOST unix://$HOME/.colima/default/docker.sock

# fzf
####
set -g FZF_DEFAULT_OPTS '--height 50% --layout=reverse --border --inline-info --preview "bat --color \"always\" {}" --bind="ctrl-o:execute(code {})+abort"'
set -g FZF_DEFAULT_COMMAND 'fd . "$dir" --type f -L -E .git -E node_modules '
set -g FZF_CTRL_T_COMMAND $FZF_DEFAULT_COMMAND 
set -g FZF_ALT_C_COMMAND 'fd . "$dir" --type d -E .git -E node_modules'
set -g FZF_ALT_C_OPTS '--preview "tree -C {} | head -100"'


test -e {$HOME}/.iterm2_shell_integration.fish ; and source {$HOME}/.iterm2_shell_integration.fish

if status is-login; and test (uname) = Darwin
    ssh-add -q --apple-load-keychain
end

set PATH $PATH $HOME/.local/bin
command -v zoxide >/dev/null; and zoxide init fish | source
