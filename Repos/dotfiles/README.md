git clone https://github.com/johnmog/dotfiles $HOME/Repos/dotfiles
alias dotfiles='/usr/bin/git --git-dir=$HOME/Repos/dotfiles/.git --work-tree=$HOME'
dotfiles config --local status.showUntrackedFiles no
echo "dotfiles" >> $HOME/Repos/.gitignore