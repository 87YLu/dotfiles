# dotfiles

## how to use

`git clone https://github.com/87YLu/dotfiles.git`

`ln -s ~/dotfiles/\$HOME/npmrc ~/.npmrc`

`ln -s ~/dotfiles/\$HOME/zshrc ~/.zshrc`

`ln -s ~/dotfiles/nvim ~/.config/nvim`

`ln -s ~/dotfiles/lazygit/config.yml ~/Library/Application\ Support/lazygit/config.yml`

Unzip the files under *nvim/plugins-backup* first

`ln -s ~/dotfiles/nvim/plugins-backup/lazy ~/.local/share/nvim/lazy`

`ln -s ~/dotfiles/nvim/plugins-backup/coc ~/.config/coc`

## Prerequisites

### nerd font

https://www.nerdfonts.com/font-downloads

### nvim

| dependence | download             |
| ---------- | -------------------- |
| ripgrep    | brew install ripgrep |
| wget       | brew install wget    |
| fd-find    | npm i fd-find -g     |

### lazygit

| dependence                                       | download               |
| ------------------------------------------------ | ---------------------- |
| [git-delta](https://github.com/dandavison/delta) | brew install git-delta |
