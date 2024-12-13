#alias dotfiles='/usr/bin/git --git-dir=$HOME/Repos/dotfiles/.git --work-tree=$HOME'
#git clone https://github.com/johnmog/dotfiles $HOME/Repos/dotfiles
#dotfiles config --local status.showUntrackedFiles no

#cd ~/Repos/dotfiles
#for file in {.[\!.]*,*}; do
#    ln -sf ~/Repos/dotfiles/"$file" ~/"$file"
#done
#ln -sf ~/Repos/dotfiles/.shellrc ~/
#cd ~/

echo >> /home/vscode/.bashrc
echo 'eval "$(/home/linuxbrew/.linuxbrew/bin/brew shellenv)"' >> /home/vscode/.bashrc
eval "$(/home/linuxbrew/.linuxbrew/bin/brew shellenv)"

/bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"

brew install iterm2
sh -c "$(curl -fsSL https://raw.github.com/ohmyzsh/ohmyzsh/master/tools/install.sh)"
git clone https://github.com/romkatv/powerlevel10k.git $ZSH_CUSTOM/themes/powerlevel10k
echo "Set solarized dark theme in iTerm with CMD+i"
read
echo "Set key bindings in iTerm Cmd+<- = b, other is f, Cmd+Del = 0x15"
read
git clone https://github.com/zsh-users/zsh-syntax-highlighting.git ~/Repos/zsh-syntax-highlighting
git clone https://github.com/zsh-users/zsh-autosuggestions ${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/zsh-autosuggestions
chsh -s /bin/zsh
brew install fzf
$(brew --prefix)/opt/fzf/install
brew install autojump

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

export EDITOR='code'

brew install --cask powershell
echo ZSH_AUTOSUGGEST_HIGHLIGHT_STYLE=\'fg=60\' >> $ZSH_CUSTOM/zsh-autosuggestions_custom.zsh

brew install wget

echo "in code, use command to install code to path"
read
