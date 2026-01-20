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
```

### tmux

```sh
ln -s ~/dotfiles/tmux/.tmux.conf ~/.tmux.conf
```

## Prerequisites

### nerd font

<https://www.nerdfonts.com/font-downloads>

### lazygit

| dependence                                       | download               |
| ------------------------------------------------ | ---------------------- |
| [git-delta](https://github.com/dandavison/delta) | brew install git-delta |
