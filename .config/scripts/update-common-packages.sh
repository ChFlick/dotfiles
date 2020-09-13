#!/bin/bash
./find-common-packages.sh
/usr/bin/git --git-dir=$HOME/.dotfiles/ --work-tree=$HOME add $HOME/pkglists/pkglist.common.txt
/usr/bin/git --git-dir=$HOME/.dotfiles/ --work-tree=$HOME commit -m "Update common package list"
