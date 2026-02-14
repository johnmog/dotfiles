# Dotfiles

Personal dotfiles and configuration files for shell environments (zsh, bash), vim, and related tools.

## Features

- **Shell Configuration**: Zsh with Oh My Zsh, custom plugins, and aliases
- **Vim Setup**: Vim with vim-plug, onedark theme, and powerline fonts
- **CLI Tools**: fzf, fd, autojump, prettyping, starship prompt
- **Private Dotfiles**: Optional integration with a private dotfiles repository

## Installation

Run the bootstrap script to set up your environment:

```bash
bash bootstrap.sh
```

The script will:
1. Clone this dotfiles repository as a bare repo to `~/.dotfiles`
2. Install Oh My Zsh with plugins
3. Install CLI tools (fzf, fd, autojump, etc.)
4. Set up Vim with plugins and themes
5. Optionally pull additional files from a private dotfiles repository

## Private Dotfiles Integration

The bootstrap script supports pulling additional configuration from a private repository called `dotfiles-private`. This is useful for:
- Storing sensitive configuration (API keys, tokens, private settings)
- Keeping work-specific or machine-specific configs separate
- Maintaining organization-specific dotfiles

### Setup

1. Create a private repository called `dotfiles-private` on GitHub
2. Add a `bootstrap-private.sh` script to the root of the repository
3. Set the `GITHUB_TOKEN` environment variable with a token that has access to the private repo
4. Run `bootstrap.sh`

### How It Works

During bootstrap, the script will:
1. Check if `GITHUB_TOKEN` is available
2. Attempt to clone `https://github.com/johnmog/dotfiles-private` to `~/.dotfiles-private`
3. If successful, run `bootstrap-private.sh` from the private repo
4. If any step fails (no token, bad token, repo doesn't exist, script fails), the bootstrap continues gracefully

### Security Notes

- The private bootstrap script runs with the same privileges as the main bootstrap script
- Review the contents of `bootstrap-private.sh` before running it
- The script validates that `bootstrap-private.sh` is in the expected directory to prevent path traversal attacks
- Symbolic link attacks are prevented by resolving the real path before execution

### Example Private Bootstrap Script

```bash
#!/bin/bash

# bootstrap-private.sh - Example private dotfiles bootstrap

log() {
  echo "[$(date +'%Y-%m-%d %H:%M:%S')] $1"
}

log "Setting up private dotfiles..."

# Copy private config files
if [ -f "$HOME/.dotfiles-private/.secrets" ]; then
  cp "$HOME/.dotfiles-private/.secrets" "$HOME/.secrets"
  log "Private secrets file copied"
fi

# Set up work-specific aliases
if [ -f "$HOME/.dotfiles-private/.work_aliases" ]; then
  echo "source ~/.dotfiles-private/.work_aliases" >> "$HOME/.zshrc"
  log "Work aliases configured"
fi

log "Private dotfiles setup complete!"
```

## Directory Structure

```
.
├── bootstrap.sh              # Main setup script
├── .config/                  # Application configs
├── .copilot/                 # GitHub Copilot instructions
├── .shellrc/                 # Additional shell configs
│   └── zshrc/               # Zsh-specific configs
├── .zshrc                    # Main Zsh configuration
├── .vimrc                    # Vim configuration
├── .gitconfig                # Git configuration
├── ext_list.txt              # Extensions list
└── fix_ext.sh               # Extension fixing script
```

## Requirements

- Bash
- Git
- curl/wget
- sudo access (for some installations)

## Environment-Specific Behavior

The bootstrap script detects whether it's running in:
- **GitHub Codespaces**: Uses direct installations and apt-get for faster setup
- **Local Machine**: Uses Homebrew for package management

## Contributing

This is a personal dotfiles repository, but feel free to fork it and adapt it to your needs!

## License

MIT
