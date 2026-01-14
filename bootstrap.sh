#!/bin/bash

# Exit on error
set -e

# Define log function for better error reporting
log() {
  echo "[$(date +'%Y-%m-%d %H:%M:%S')] $1"
}
# Export log function for use in background jobs
export -f log

# Arrays to track background job PIDs and names for parallel execution
PARALLEL_PIDS=()
PARALLEL_NAMES=()

# Run a command in the background and track its PID
# Usage: run_parallel <function_name> [args...]
run_parallel() {
  local cmd_name="$1"
  "$@" &
  local pid=$!
  # Verify the background process started
  if [[ -n "$pid" ]] && kill -0 "$pid" 2>/dev/null; then
    PARALLEL_PIDS+=("$pid")
    PARALLEL_NAMES+=("$cmd_name")
  else
    log "WARNING: Failed to start background job: $cmd_name"
  fi
}

# Wait for all tracked parallel jobs to complete
# Returns 0 if all jobs succeeded, 1 if any failed
# Logs which specific jobs failed
wait_parallel() {
  local failed=0
  local failed_jobs=()
  
  # Handle empty array case
  if [[ ${#PARALLEL_PIDS[@]} -eq 0 ]]; then
    return 0
  fi
  
  for i in "${!PARALLEL_PIDS[@]}"; do
    local pid="${PARALLEL_PIDS[$i]}"
    local name="${PARALLEL_NAMES[$i]:-unknown}"
    if ! wait "$pid"; then
      failed=1
      failed_jobs+=("$name")
    fi
  done
  
  if [[ $failed -eq 1 ]]; then
    log "WARNING: The following jobs failed: ${failed_jobs[*]}"
  fi
  
  PARALLEL_PIDS=()
  PARALLEL_NAMES=()
  return $failed
}

install_fzf_codespace() {
  if ! command -v fzf &>/dev/null; then
    log "Installing fzf directly in codespace..."
    git clone --depth 1 https://github.com/junegunn/fzf.git ~/.fzf
    # Use --no-fish to skip fish shell configuration which fails in Codespaces
    ~/.fzf/install --all --no-update-rc --no-fish
  else
    log "fzf already installed"
  fi
}
export -f install_fzf_codespace

install_fd_codespace() {
  if ! command -v fd &>/dev/null; then
    log "Installing fd directly in codespace..."
    FD_VERSION="10.2.0"
    FD_FILENAME="fd-v${FD_VERSION}-x86_64-unknown-linux-gnu.tar.gz"
    FD_URL="https://github.com/sharkdp/fd/releases/download/v${FD_VERSION}/${FD_FILENAME}"
    
    # Download to temporary file - use unique name based on PID
    TEMP_FILE="/tmp/fd-$$-${FD_FILENAME}"
    log "Downloading fd from ${FD_URL}..."
    curl -L -o "${TEMP_FILE}" "${FD_URL}"
    
    # Extract to unique directory and install
    EXTRACT_DIR="/tmp/fd-extract-$$"
    mkdir -p "$EXTRACT_DIR"
    tar -xz -f "${TEMP_FILE}" -C "$EXTRACT_DIR"
    sudo mv "$EXTRACT_DIR/fd-v${FD_VERSION}-x86_64-unknown-linux-gnu/fd" /usr/local/bin/
    rm -rf "$EXTRACT_DIR" "${TEMP_FILE}"
    log "fd installed successfully"
  else
    log "fd already installed"
  fi
}
export -f install_fd_codespace

install_autojump_codespace() {
  if ! command -v autojump &>/dev/null; then
    log "Installing autojump directly in codespace..."
    TEMP_DIR="/tmp/autojump-$$"  # Use PID for unique temp directory
    git clone https://github.com/wting/autojump.git "$TEMP_DIR"
    cd "$TEMP_DIR" || { log "ERROR: Failed to enter autojump directory"; return 1; }
    # Security: Verify we're in the right directory before executing
    if [[ -f "install.py" && -f "bin/autojump" ]]; then
      ./install.py
    else
      log "ERROR: autojump installation files not found"
      cd - > /dev/null
      rm -rf "$TEMP_DIR"
      return 1
    fi
    cd - > /dev/null
    rm -rf "$TEMP_DIR"
  else
    log "autojump already installed"
  fi
}
export -f install_autojump_codespace

install_prettyping_codespace() {
  if ! command -v prettyping &>/dev/null; then
    log "Installing prettyping directly in codespace..."
    PRETTYPING_URL="https://raw.githubusercontent.com/denilsonsa/prettyping/master/prettyping"
    PRETTYPING_PATH="/usr/local/bin/prettyping"
    
    # Download prettyping
    log "Downloading prettyping from ${PRETTYPING_URL}..."
    sudo wget -q "${PRETTYPING_URL}" -O "${PRETTYPING_PATH}"
    
    # Make it executable
    sudo chmod +x "${PRETTYPING_PATH}"
    log "prettyping installed successfully"
  else
    log "prettyping already installed"
  fi
}
export -f install_prettyping_codespace

install_starship_codespace() {
  if ! command -v starship &>/dev/null; then
    log "Installing starship directly in codespace..."
    curl -sS https://starship.rs/install.sh | sh -s -- -y
  else
    log "starship already installed"
    return 0
  fi
}
export -f install_starship_codespace

install_nvm() {
  # Check if nvm is already installed
  if [[ -d "$HOME/.nvm" ]] && [[ -s "$HOME/.nvm/nvm.sh" ]]; then
    log "nvm already installed"
    return 0
  fi
  
  # Download and install nvm using the official installation script
  NVM_INSTALL_URL="https://raw.githubusercontent.com/nvm-sh/nvm/v0.40.3/install.sh"
  
  log "Downloading nvm installation script from ${NVM_INSTALL_URL}..."
  
  if curl -o- "$NVM_INSTALL_URL" | bash; then
    log "nvm installation script completed successfully"
    
    # Verify installation
    if [[ -d "$HOME/.nvm" ]] && [[ -s "$HOME/.nvm/nvm.sh" ]]; then
      log "nvm installed successfully"
    else
      log "ERROR: nvm installation verification failed"
      return 1
    fi
  else
    log "ERROR: Failed to download or execute nvm installation script"
    return 1
  fi
}

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
  # Security: Validate filename to prevent path traversal
  if [[ "$file" =~ \.\./|\.\. || "$file" =~ ^/ ]]; then
    log "WARNING: Skipping potentially unsafe file: $file"
    continue
  fi
  ln -sf "$HOME/.dotfiles/$file" "$HOME/$file"
done
# Explicitly symlink key dotfile directories to ensure they are properly linked
ln -sf "$HOME/.dotfiles/.shellrc" "$HOME/.shellrc"
ln -sf "$HOME/.dotfiles/.copilot" "$HOME/.copilot"
cd $HOME/

if [[ -n "$CODESPACES" ]]; then
  log "Running in Codespaces..."
  REPOS="/workspaces/.codespaces/.persistedshare"
  # Bug where shell is always bash in Codespaces
  export SHELL=/bin/zsh
  log "Set SHELL to $SHELL"
else
  REPOS="$HOME/Repos"
fi
export REPOS  # Export for use in parallel background jobs
log "Using repository path: $REPOS"

# Create repository directory if it doesn't exist
if [[ ! -d "$REPOS" ]]; then
  log "Creating repository directory: $REPOS"
  mkdir -p "$REPOS" || { log "ERROR: Failed to create repository directory"; exit 1; }
fi

# Install Homebrew if not installed (skip in codespaces)
if [[ -z "$CODESPACES" ]]; then
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
else
  log "Skipping Homebrew installation in Codespaces"
fi

# Install macOS specific applications
if [[ "$OSTYPE" =~ darwin ]]; then
  log "Installing macOS specific applications..."
  brew install --cask iterm2 || log "Failed to install iTerm2"
  brew install --cask powershell || log "Failed to install PowerShell"
fi

# Configure shell
sudo chsh -s "/bin/zsh" $(whoami) || log "Failed to change shell to zsh"

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
export ZSH_CUSTOM

install_zsh_plugin() {
  local repo_url="$1"
  local dest_dir="$2"
  
  # Input validation
  if [[ -z "$repo_url" || -z "$dest_dir" ]]; then
    log "ERROR: install_zsh_plugin requires repo_url and dest_dir parameters"
    return 1
  fi
  
  # Security: Validate destination directory is within expected path
  if [[ "$dest_dir" != "$ZSH_CUSTOM"* ]]; then
    log "ERROR: Destination directory outside of ZSH_CUSTOM: $dest_dir"
    return 1
  fi
  
  if [ ! -d "$dest_dir" ]; then
    log "Installing plugin from $repo_url to $dest_dir"
    git clone --depth=1 "$repo_url" "$dest_dir"
  else
    log "Plugin already installed: $dest_dir"
  fi
}
export -f install_zsh_plugin

# Install zsh plugins in parallel for faster setup
log "Installing Zsh plugins in parallel..."
run_parallel install_zsh_plugin "https://github.com/zsh-users/zsh-syntax-highlighting.git" "$ZSH_CUSTOM/plugins/zsh-syntax-highlighting"
run_parallel install_zsh_plugin "https://github.com/zsh-users/zsh-autosuggestions" "$ZSH_CUSTOM/plugins/zsh-autosuggestions"
wait_parallel

# Install command line tools
log "Installing CLI tools..."
if [[ -n "$CODESPACES" ]]; then
  # Use direct installations in codespaces for speed
  # Run all tool installations in parallel for faster setup
  log "Running CLI tool installations in parallel..."
  run_parallel install_fzf_codespace
  run_parallel install_fd_codespace
  run_parallel install_autojump_codespace
  run_parallel install_prettyping_codespace
  run_parallel install_starship_codespace
  wait_parallel
else
  # Use homebrew for non-codespace environments
  # Homebrew handles parallelization internally with --jobs
  brew install fzf fd autojump prettyping starship
  install_nvm
fi

# Install Vim plugins
log "Setting up Vim plugins..."
if [[ ! -f "$HOME/.vim/autoload/plug.vim" ]]; then
  mkdir -p "$HOME/.vim/autoload"
  curl -fLo "$HOME/.vim/autoload/plug.vim" \
      https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim
else
  log "vim-plug already installed"
fi

# Helper function to install powerline fonts
install_powerline_fonts() {
  if [ ! -d "$REPOS/powerline" ]; then
    log "Cloning powerline fonts..."
    git clone --depth=1 https://github.com/powerline/fonts.git "$REPOS/powerline"
    # Security: Verify we have the expected script before executing
    if [[ -f "$REPOS/powerline/install.sh" && -x "$REPOS/powerline/install.sh" ]]; then
      (cd "$REPOS/powerline" && ./install.sh)
    else
      log "ERROR: powerline install.sh not found or not executable"
      return 1
    fi
  else
    log "Powerline fonts already installed"
  fi
}
export -f install_powerline_fonts

# Helper function to install onedark theme
install_onedark_theme() {
  if [ ! -d "$REPOS/onedark" ]; then
    log "Cloning onedark theme..."
    git clone --depth=1 https://github.com/joshdick/onedark.vim.git "$REPOS/onedark"
    mkdir -p "$HOME/.vim/colors" "$HOME/.vim/autoload"
    cp "$REPOS/onedark/colors/onedark.vim" "$HOME/.vim/colors/"
    cp "$REPOS/onedark/autoload/onedark.vim" "$HOME/.vim/autoload/"
  else
    log "Onedark theme already installed"
  fi
}
export -f install_onedark_theme

# Install powerline fonts and onedark theme in parallel
log "Installing fonts and themes in parallel..."
run_parallel install_powerline_fonts
run_parallel install_onedark_theme
wait_parallel

log "Installing wget..."
if [[ -n "$CODESPACES" ]]; then
  # Use apt-get in codespaces (much faster than homebrew)
  if ! command -v wget &>/dev/null; then
    sudo apt-get update -qq && sudo apt-get install -qq -y wget
  else
    log "wget already installed"
  fi
else
  # Use homebrew for non-codespace environments
  brew install wget
fi

log "=== Setup instructions ==="
log "1. Set solarized dark theme in iTerm with CMD+i"
log "2. Set key bindings in iTerm: Cmd+<- = b, other is f, Cmd+Del = 0x15"
log "3. In VS Code, use command palette to install 'code' command in PATH"
log "Setup complete!"
log "=========================="
