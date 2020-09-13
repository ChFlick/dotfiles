#!/bin/bash
GITCONFIG_LOCAL=$HOME/.gitconfig.local
GITCONFIG_LOCAL_DEFAULT=$HOME/.gitconfig.local.default

FISHCONFIG=$HOME/.config/fish/config.fish
FISHCONFIG_LOCAL=$HOME/.config/fish/config.local.fish

INSTALL_HOOK=$HOME/.config/pacman-hooks/explicit-install-list.hook
PACMAN_HOOK_DIR=/usr/share/libalpm/hooks 


## Fetch device id
if [ -z $DOTFILES_DEVICE_ID ]; then
        echo "How is this device called?"
        read device_id
else
        device_id=$DOTFILES_DEVICE_ID
fi


## Init local fish config
if [ ! -f $FISHCONFIG_LOCAL ]; then
    echo "There is currently no local fish config. Creating one..."

    touch $FISHCONFIG_LOCAL
    echo "set -X DOTFILES_DEVICE_ID '$device_id'" >> $FISHCONFIG_LOCAL
    echo "$FISHCONFIG_LOCAL created and DOTFILES_DEVICE_ID set to environment"
fi


## Init local git config
if [ ! -f $GITCONFIG_LOCAL ]; then
    echo "There is currently no local git config. Creating one..."

    cp $GITCONFIG_LOCAL_DEFAULT $GITCONFIG_LOCAL
    echo "$GITCONFIG_LOCAL created"
    echo "Please make sure to set the GPG key in $GITCONFIG_LOCAL"
fi


## Install pacman hook
echo "Symlinking pacman hook to hook directory..."
if [ ! -f $PACMAN_HOOK_DIR/explicit-install-list.hook ]; then
    sudo ln -s $INSTALL_HOOK $PACMAN_HOOK_DIR/explicit-install-list.hook
    echo "Linked $INSTALL_HOOK to $PACMAN_HOOK_DIR"
else
    echo "But the hook already exists."
fi
