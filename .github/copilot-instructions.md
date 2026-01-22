# GitHub Copilot Instructions

This repository contains personal dotfiles and configuration files for shell environments (zsh, bash), vim, and related tools.

## Repository Structure

- `.zshrc` - Zsh shell configuration
- `.vimrc` - Vim editor configuration
- `.shellrc/` - Additional shell configuration files
- `.shellrc/zshrc/` - Zsh-specific configuration files
- `bootstrap.sh` - Main installation and setup script
- `.gitconfig` - Git configuration
- `.config/` - Application-specific configuration directory
- `.copilot/` - GitHub Copilot skills and custom instructions
- `.gitignore` - Git ignore patterns
- `ext_list.txt` - List of extensions
- `fix_ext.sh` - Extension fixing script

## Shell Scripting Standards

### Bash/Shell Scripts

- Always use `#!/bin/bash` shebang for bash scripts
- Use `set -e` to exit on error in setup scripts
- Add comprehensive error handling with informative log messages
- Use functions with clear names and single responsibilities
- Always validate inputs and paths before using them
- Include comments for complex logic or non-obvious operations

### Security Practices

- Never hardcode sensitive data (API keys, passwords, tokens)
- Validate file paths to prevent path traversal attacks
- Check for command existence before executing with `command -v`
- Use secure download methods (https, verify checksums when possible)
- Validate that scripts exist and are executable before running them
- Sanitize user inputs and environment variables
- Use safe temporary directories with unique names (e.g., using `$$` for PID)

### Logging

- Use consistent log function format: `log() { echo "[$(date +'%Y-%m-%d %H:%M:%S')] $1"; }`
- Log all major operations, installations, and errors
- Include timestamps in log messages
- Use descriptive error messages that help with debugging

### Installation Functions

- Check if tool is already installed before attempting installation
- Use conditional installation based on environment (Codespaces vs local)
- Return appropriate exit codes (0 for success, 1 for failure)
- Clean up temporary files and directories after installation
- Verify successful installation before proceeding

## Configuration File Standards

### Zsh Configuration

- Organize plugins in the `plugins=()` array
- Source additional configurations from `.shellrc/zshrc/` directory
- Use clear variable names and export them appropriately
- Document any non-standard key bindings

### Vim Configuration

- Use vim-plug for plugin management
- Include comments for plugin purposes
- Set sensible defaults for editing (tabstop, expandtab, etc.)
- Use colorscheme consistently

## Git Practices

- Use clear, descriptive commit messages
- Keep commits focused and atomic
- Don't commit sensitive files (listed in `.gitignore`)
- Use bare repository pattern for dotfiles management

## Code Style

- Use 2-space indentation for shell scripts (bash/zsh)
- Use 4-space indentation for vim configuration files (as configured with `tabstop=4`)
- Use meaningful variable names in UPPER_CASE for constants
- Use lowercase for local variables
- Quote variables to prevent word splitting
- Use `[[` instead of `[` for conditionals in bash
- Prefer `$(command)` over backticks for command substitution

## Testing Considerations

- Test scripts in both Codespaces and local environments when possible
- Verify that installations work on both macOS and Linux
- Check that conditional logic handles different environments correctly
- Ensure idempotency - scripts should be safe to run multiple times
