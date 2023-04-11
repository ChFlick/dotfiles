My configuration files for Linux and macOS.

# Install git

## macOS

Install git with XCode Command Line Tools:

```sh
xcode-select --install
```

# Clone the repository

```sh
git clone git@github.com:chflick/dotfiles.git
cd dotfiles
```

# Install Ansible

```sh
./install
```

# Run playbook

```sh
ansible-playbook bootstrap.yml
```

### Credits
Credits to https://github.dev/phelipetls/dotfiles where I peeked a bit for this dotfiles setup.