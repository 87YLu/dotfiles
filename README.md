# dotfiles

## how to use

nvim and lazygit

```sh
$ git clone https://github.com/87YLu/dotfiles.git
$ ln -s ~/dotfiles/\$HOME/npmrc ~/.npmrc
$ ln -s ~/dotfiles/\$HOME/zshrc ~/.zshrc
$ ln -s ~/dotfiles/nvim ~/.config/nvim
$ ln -s ~/dotfiles/lazygit/config.yml ~/Library/Application\ Support/lazygit/config.yml
```

Unzip the files under *nvim/plugins-backup* first

```sh
$ ln -s ~/dotfiles/nvim/plugins-backup/lazy ~/.local/share/nvim/lazy
$ ln -s ~/dotfiles/nvim/plugins-backup/coc ~/.config/coc
```

[yabai](https://github.com/koekeishiya/yabai/wiki/Installing-yabai-(latest-release)#configure-scripting-addition)

```sh
$ shasum -a 256 $(which yabai) # get yabai sh and location
$ sudo nvim /etc/sudoers

# <user> ALL=(root) NOPASSWD: sha256:<hash> <yabai> --load-sa
# add this line

$ sudo yabai --load-sa
```

```sh
$ ln -s ~/dotfiles/yabai/yabairc ~/.yabairc
$ ln -s ~/dotfiles/yabai/skhdrc ~/.skhdrc
$ cd /tmp && mkdir yabai-tiling-floating-toggle
```

```sh
# start yabai
$ yabai --start-service && skhd --start-service
```

sketchybar

```sh
$ ln -s ~/dotfiles/sketchybar ~/.config/sketchybar
```

```sh
# start sketchybar
$ brew services start sketchybar
```

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

### yabai

| dependence | download                               |
| ---------- | -------------------------------------- |
| jq         | brew install jq                        |
| skhd       | brew install koekeishiya/formulae/skhd |
