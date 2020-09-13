#!/bin/bash
/usr/bin/git --git-dir=$HOME/.dotfiles/ --work-tree=$HOME add $HOME/pkglists/pkglist.$DOTFILES_DEVICE_ID.txt
/usr/bin/git --git-dir=$HOME/.dotfiles/ --work-tree=$HOME commit -m "Update package list for $DOTFILES_DEVICE_ID"
