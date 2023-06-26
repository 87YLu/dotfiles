#!/usr/bin/env bash

spaceType=$(yabai -m query --spaces --space | jq .type)

if [ $spaceType = '"bsp"' ]; then
	yabai -m space --layout float
	sketchybar --set space icon="󰉪"
else
	yabai -m space --layout bsp
	sketchybar --set space icon=""
fi

$(~/dotfiles/yabai/sh/update_front_app_name.sh)
