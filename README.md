# Dotfiles

Personal dotfiles configuration for development environment setup.

## Quick Start

```bash
./bootstrap.sh
```

## Features

- **Shell Configuration**: ZSH with Oh My Zsh, custom themes and plugins
- **Git Configuration**: Integrated GitHub CLI authentication
- **Development Tools**: fzf, fd, autojump, starship prompt
- **Vim Setup**: vim-plug with airline and NERDTree
- **VS Code Extensions**: Comprehensive list for development

## Security

### Secrets Management

This repository uses a `.secrets` file pattern for managing environment-specific secrets. The `.secrets` file is automatically sourced by `.zshrc` if it exists.

**To use secrets:**

1. Create `~/.secrets` file in your home directory:
   ```bash
   touch ~/.secrets
   chmod 600 ~/.secrets
   ```

2. Add your environment-specific secrets:
   ```bash
   # Example .secrets file content
   export MY_API_KEY="your-api-key-here"
   export MY_TOKEN="your-token-here"
   export DATABASE_PASSWORD="your-password-here"
   ```

3. The file will be automatically loaded when you start a new shell session.

**Important:** Never commit the `.secrets` file to git. It's already included in `.gitignore`.

### Security Analysis

A comprehensive security analysis has been performed on this repository. See [SECURITY_ANALYSIS.md](SECURITY_ANALYSIS.md) for details.

**Key Security Features:**
- ✅ No secrets in repository or git history
- ✅ Proper credential management with GitHub CLI
- ✅ Input validation in scripts
- ✅ Path traversal protection
- ✅ Secure SSH key handling (public key only)

## File Structure

```
.
├── .config/           # Application configurations
│   └── starship.toml  # Starship prompt configuration
├── .shellrc/          # Shell configuration modules
│   └── zshrc/         # ZSH-specific configurations
├── .gitconfig         # Git configuration
├── .gitignore         # Git ignore patterns
├── .vimrc             # Vim configuration
├── .zshrc             # ZSH configuration
├── bootstrap.sh       # Setup script
├── ext_list.txt       # VS Code extensions list
└── fix_ext.sh         # macOS file association script
```

## Installation

The `bootstrap.sh` script will:
1. Clone the dotfiles repository as a bare git repo
2. Install Oh My Zsh and plugins
3. Install command-line tools (fzf, fd, autojump, etc.)
4. Set up Vim with vim-plug
5. Configure shell and git settings

### Supported Platforms

- macOS (primary)
- Linux
- GitHub Codespaces

## Customization

### Adding Your Own Secrets

1. Create your `.secrets` file (see Security section above)
2. Add your API keys, tokens, or other secrets
3. Ensure the file has restrictive permissions: `chmod 600 ~/.secrets`

### Adding Shell Configurations

Add new `.rc` files to `.shellrc/zshrc/` directory. They will be automatically sourced by `.zshrc`.

### Adding VS Code Extensions

Update `ext_list.txt` and run:
```bash
tail -n +3 ext_list.txt | xargs -n 1 code --install-extension
```

## Useful Aliases

### Git
- `gbn` - Copy current branch name
- `gcb <branch>` - Delete branch locally and remotely
- `gpull` - Pull current branch
- `gbranch <name>` - Create and push new branch

### General
- `ll` - List all files
- `mkcd <dir>` - Create directory and cd into it
- `pkey` - Copy SSH public key to clipboard

### Containers
- `k` - kubectl shorthand
- `d` - docker shorthand
- `dc` - docker-compose shorthand

## License

Personal configuration files - use at your own risk.
