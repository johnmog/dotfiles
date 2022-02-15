# Homebrew
/bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"

# Terminal
brew cask install iterm2
sh -c "$(curl -fsSL https://raw.github.com/ohmyzsh/ohmyzsh/master/tools/install.sh)"
git clone --depth=1 https://github.com/romkatv/powerlevel10k.git ~/powerlevel10k
chsh -s /bin/zsh
brew install fzf
$(brew --prefix)/opt/fzf/install

# VIM
curl -fLo ~/.vim/autoload/plug.vim --create-dirs \
    https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim

git clone https://github.com/powerline/fonts.git --depth=1
  cd fonts
  ./install.sh
  cd ..
  rm -rf fonts

git clone https://github.com/joshdick/onedark.vim.git ~/onedark
  cd ~/onedark
  mkdir ~/.vim/colors
  cp colors/onedark.vim ~/.vim/colors/
  cp autoload/onedark.vim ~/.vim/autoload/

# VSCODE
export EDITOR='code'
