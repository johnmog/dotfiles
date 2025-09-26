# History
HISTFILE=$HOME/.zsh_history
HISTSIZE=100000
SAVEHIST=100000

setopt INC_APPEND_HISTORY     # Immediately append to history file.
setopt EXTENDED_HISTORY       # Record timestamp in history.
setopt HIST_EXPIRE_DUPS_FIRST # Expire duplicate entries first when trimming history.
setopt HIST_IGNORE_DUPS       # Dont record an entry that was just recorded again.
setopt HIST_IGNORE_ALL_DUPS   # Delete old recorded entry if new entry is a duplicate.
setopt HIST_FIND_NO_DUPS      # Do not display a line previously found.
setopt HIST_IGNORE_SPACE      # Dont record an entry starting with a space.
setopt HIST_REDUCE_BLANKS     # Remove superfluous blanks from each command before recording it.
setopt HIST_SAVE_NO_DUPS      # Dont write duplicate entries in the history file.
setopt SHARE_HISTORY          # Share history between all sessions.

# Path to your oh-my-zsh installation.
export ZSH="$HOME/.oh-my-zsh"

plugins=(git brew autojump zsh-autosuggestions zsh-syntax-highlighting)

source $ZSH/oh-my-zsh.sh

# Load all files from .shell/zshrc.d directory
if [ -d $HOME/.shellrc/zshrc ]; then
  for file in $HOME/.shellrc/zshrc/*.rc; do
    source $file
  done
fi

# keybindings
bindkey "^E" forward-word
bindkey "^A" backward-word

# ensure verbose logging for GitHub Copilot
export GITHUB_COPILOT_VERBOSE=true
export EDITOR='code'

alias dotfiles='/usr/bin/git --git-dir=$HOME/.dotfiles/ --work-tree=$HOME'

ZSH_AUTOSUGGEST_HIGHLIGHT_STYLE='fg=60'

eval "$(starship init zsh)"
source <(fzf --zsh)

# nvm configuration
export NVM_DIR="$HOME/.nvm"
[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"
[ -s "$NVM_DIR/bash_completion" ] && \. "$NVM_DIR/bash_completion"

if [ -f "$HOME/.secrets" ]; then
  source "$HOME/.secrets"
fi
