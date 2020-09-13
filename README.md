# dotfiles
My personal dotfiles

## Installation

Run the following commands to install the dotfiles on your system.
**Warning:** The files in the dotfiles repository will override local files, like `~/.gitconfig`.

```bash
git clone --bare https://www.github.com:ChFlick/dotfiles.git $HOME/.dotfiles
alias dotfiles="/usr/bin/git --git-dir=$HOME/.dotfiles/ --work-tree=$HOME"
dotfiles restore --staged .
dotfiles restore .
dotfiles config --local status.showUntrackedFiles no
source ~/.config/fish/config.fish
```

The `dotfiles` commmand can be used to interact with the dotfiles repository, it is already set as alias in `aliases.fish`.

After the checkout, execute `.config/scripts/init-dotfiles.sh`

## Pkglists

The `pkglists` folder contains all explicitly installed pacman/AUR dependencies, split by device ID's.

