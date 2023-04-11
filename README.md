My configuration files for Linux and macOS.

# Install git

## macOS

Install XCode Command Line Tools, Brew, yadm, and then pull the dotfiles

```sh
xcode-select --install
/bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
brew install yadm
yadm clone https://github.com/chflick/dotfiles.git
```

### Credits
Credits to https://github.dev/phelipetls/dotfiles where I peeked a bit for the ansible setup.
