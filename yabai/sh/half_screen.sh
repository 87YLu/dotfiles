#!/usr/bin/env bash

floating=$(echo $(yabai -m query --windows --window | jq '."is-floating"'))

if [[ $floating = false ]]; then
	yabai -m window --toggle float
	$(~/dotfiles/yabai/sh/update_front_app_name.sh)
fi

if [[ $1 == 'left' ]]; then
	yabai -m window --grid 1:2:0:0:1:1
else
	yabai -m window --grid 1:2:1:0:1:1
fi
