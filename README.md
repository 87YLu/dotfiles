# dotfiles

## how to use

### nvim and lazygit

```sh
git clone https://github.com/87YLu/dotfiles.git
ln -s ~/dotfiles/\$HOME/npmrc ~/.npmrc
ln -s ~/dotfiles/\$HOME/zshrc ~/.zshrc
ln -s ~/dotfiles/nvim ~/.config/nvim
ln -s ~/dotfiles/lazygit/config.yml ~/Library/Application\ Support/lazygit/config.yml
```

### terminals

```sh
ln -s ~/dotfiles/terminals/kitty ~/.config/kitty
```

```sh
ln -s ~/dotfiles/terminals/alacritty ~/.config/alacritty
```

```sh
ln -s ~/dotfiles/terminals/wezterm ~/.config/wezterm
```

If you want to change the background image regularly

```sh
touch ~/dotfiles/terminals/backgrounds_path.sh
```

add this line in file `~/dotfiles/terminals/backgrounds_path.sh`

```sh
export backgrounds_path="your path"
```

run `crontab -e` and add

```sh
# kitty
*/15 * * * *  /bin/bash $HOME/dotfiles/terminals/kitty/change_background_image.sh
# iTerm2
*/15 * * * *  /bin/bash $HOME/dotfiles/terminals/iTerm2/change_background_image.sh
```

### tmux

```sh
ln -s ~/dotfiles/tmux/.tmux.conf ~/.tmux.conf
```

### [yabai](https://github.com/koekeishiya/yabai/wiki/Installing-yabai-(latest-release)#configure-scripting-addition)

```sh
$ shasum -a 256 $(which yabai) # get yabai sh and location
$ sudo nvim /etc/sudoers

# <user> ALL=(root) NOPASSWD: sha256:<hash> <yabai> --load-sa
# add this line

$ sudo yabai --load-sa
```

```sh
ln -s ~/dotfiles/yabai/yabairc ~/.yabairc
ln -s ~/dotfiles/yabai/skhdrc ~/.skhdrc
```

```sh
# start yabai
$ yabai --start-service && skhd --start-service
$ sudo yabai --load-sa
```

### sketchybar

```sh
ln -s ~/dotfiles/sketchybar ~/.config/sketchybar
```

```sh
# start sketchybar
$ brew services start sketchybar
```

### hammerspoon

```sh
ln -s ~/dotfiles/hammerspoon ~/.hammerspoon
```

### [stackline](https://github.com/AdamWagner/stackline)

1. Ensure Hammerspoon is running
2. Open the hammerspoon console via the menu bar
3. Type `hs.ipc.cliInstall("/opt/homebrew"`) and hit return
4. Type `hs -c 'stackline.config:toggle("appearance.showIcons")'` in the terminal and hit return

## Prerequisites

### nerd font

<https://www.nerdfonts.com/font-downloads>

### nvim

| dependence | download             |
| ---------- | -------------------- |
| ripgrep    | brew install ripgrep |
| wget       | brew install wget    |
| fd-find    | npm i fd-find -g     |
| shfmt      | brew install shfmt   |

### lazygit

| dependence                                       | download               |
| ------------------------------------------------ | ---------------------- |
| [git-delta](https://github.com/dandavison/delta) | brew install git-delta |

### yabai

| dependence | download                               |
| ---------- | -------------------------------------- |
| jq         | brew install jq                        |
| skhd       | brew install koekeishiya/formulae/skhd |

### sketchybar

weather api <https://dev.qweather.com/>

download [location shortcut](https://www.icloud.com/shortcuts/30dc2bd916c54153b65805e6c9193527)
