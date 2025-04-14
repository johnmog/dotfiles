#!/bin/bash

# Exit on error
set -e

# Define log function for better error reporting
log() {
  echo "[$(date +'%Y-%m-%d %H:%M:%S')] $1"
}

if [[ -n "$CODESPACES" ]]; then
  log "Running in Codespaces..."
  REPOS="/workspaces/.codespaces/.persistedshare"
else
  REPOS="$HOME/Repos"
fi
log "Using repository path: $REPOS"

# Ensure the repository exists
if [[ ! -d "$HOME/.dotfiles/" ]]; then
  log "Cloning dotfiles repository..."
  git clone --bare https://github.com/johnmog/dotfiles "$HOME/.dotfiles"
  dotfiles() {
    git --git-dir="$HOME/.dotfiles" --work-tree="$HOME" "$@"
  }
  dotfiles checkout -f
  dotfiles config --local status.showUntrackedFiles no
fi

# Create symbolic links for every file in the dotfiles repository
for file in $(ls -A "$HOME/.dotfiles"); do
  if [[ "$file" == ".git" || "$file" == ".gitignore" || "$file" == ".gitmodules" ]]; then
    continue
  fi
  ln -sf "$file" "$HOME/$file"
done
ln -sf "$HOME/.dotfiles/.shellrc" "$HOME/.shellrc"
cd $HOME/

# Install Homebrew if not installed
if ! command -v brew &>/dev/null; then
  log "Installing Homebrew..."
  /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
fi

# Add Homebrew to PATH
if [[ "$OSTYPE" =~ darwin ]]; then
  eval "$(/opt/homebrew/bin/brew shellenv)"
else
  eval "$(/home/linuxbrew/.linuxbrew/bin/brew shellenv)"
fi

# Install macOS specific applications
if [[ "$OSTYPE" =~ darwin ]]; then
  log "Installing macOS specific applications..."
  brew install --cask iterm2 || log "Failed to install iTerm2"
  brew install --cask powershell || log "Failed to install PowerShell"
fi

# Install Oh My Zsh
if [ ! -d "$HOME/.oh-my-zsh" ]; then
  log "Installing Oh My Zsh..."
  sh -c "$(curl -fsSL https://raw.github.com/ohmyzsh/ohmyzsh/master/tools/install.sh)" "" --unattended
else
  log "Oh My Zsh is already installed"
fi

log "Installing Zsh themes and plugins..."

# Set ZSH_CUSTOM if not already set
if [ -z "$ZSH_CUSTOM" ]; then
  ZSH_CUSTOM="$HOME/.oh-my-zsh/custom"
fi

install_zsh_plugin() {
  local repo_url=$1
  local dest_dir=$2
  if [ ! -d "$dest_dir" ]; then
    git clone --depth=1 "$repo_url" "$dest_dir"
  fi
}

install_zsh_plugin "https://github.com/romkatv/powerlevel10k.git" "$ZSH_CUSTOM/themes/powerlevel10k"
install_zsh_plugin "https://github.com/zsh-users/zsh-syntax-highlighting.git" "$ZSH_CUSTOM/plugins/zsh-syntax-highlighting"
install_zsh_plugin "https://github.com/zsh-users/zsh-autosuggestions" "$ZSH_CUSTOM/plugins/zsh-autosuggestions"

# Configure shell
if [ "$SHELL" != "/bin/zsh" ]; then
  log "Setting up zsh as default shell..." 
  sudo chsh -s /bin/zsh "$(whoami)"
fi

# Install command line tools
log "Installing CLI tools..."
brew install fzf || log "Failed to install fzf"
"$(brew --prefix)"/opt/fzf/install --all --no-bash --no-fish
brew install autojump || log "Failed to install autojump"

# Install Vim plugins
log "Setting up Vim plugins..."
curl -fLo ~/.vim/autoload/plug.vim --create-dirs \
    https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim

if [ ! -d "$REPOS/powerline" ]; then
  git clone --depth=1 https://github.com/powerline/fonts.git "$REPOS/powerline"
  (cd "$REPOS/powerline" && ./install.sh)
fi

if [ ! -d "$REPOS/onedark" ]; then
  git clone --depth=1 https://github.com/joshdick/onedark.vim.git "$REPOS/onedark"
  mkdir -p "$HOME/.vim/colors" "$HOME/.vim/autoload"
  cp "$REPOS/onedark/colors/onedark.vim" "$HOME/.vim/colors/"
  cp "$REPOS/onedark/autoload/onedark.vim" "$HOME/.vim/autoload/"
fi

log "Installing wget..."
brew install wget || log "Failed to install wget"

log "=== Setup instructions ==="
log "1. Set solarized dark theme in iTerm with CMD+i"
log "2. Set key bindings in iTerm: Cmd+<- = b, other is f, Cmd+Del = 0x15"
log "3. In VS Code, use command palette to install 'code' command in PATH"
log "Setup complete!"
log "=========================="
