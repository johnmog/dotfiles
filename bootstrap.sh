#!/bin/bash

# Exit immediately if a command exits with a non-zero status
set -e

# Define variables for paths
HOME_DIR="$HOME"
DOTFILES_DIR="$HOME_DIR/Repos/dotfiles"
BASHRC_PATH="$HOME_DIR/.bashrc"
LINUXBREW_PATH="$HOME_DIR/.linuxbrew/bin/brew"

# Clone the dotfiles repository if it doesn't exist
if [ ! -d "$DOTFILES_DIR" ]; then
  echo "Cloning dotfiles repository..."
  git clone https://github.com/johnmog/dotfiles "$DOTFILES_DIR"
else
  echo "Dotfiles repository already exists. Skipping clone."
fi

# Check if Linuxbrew is installed
if [ ! -f "$LINUXBREW_PATH" ]; then
  echo "Installing Linuxbrew..."
  /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
else
  echo "Linuxbrew is already installed. Skipping installation."
fi

# Set up fzf if not already installed
if ! command -v fzf &> /dev/null; then
  echo "Installing fzf..."
  brew install fzf
else
  echo "fzf is already installed. Skipping installation."
fi

# Set up autojump if not already installed
if ! command -v autojump &> /dev/null; then
  echo "Installing autojump..."
  brew install autojump
else
  echo "autojump is already installed. Skipping installation."
fi

# Export default editor
export EDITOR="code"

# Add comments to explain each section
# This script sets up the development environment by cloning repositories,
# installing necessary tools, and configuring the shell environment.

# Additional setup commands can be added below
# ...existing code...

# End of script