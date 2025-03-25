#!/usr/bin/env bash

floating=$(echo $(yabai -m query --windows --window | jq '."is-floating"'))

if [[ $floating = true ]]; then
	yabai -m window --toggle float
	$(~/dotfiles/yabai/sh/update_front_app_name.sh)
fi

yabai -m window --toggle zoom-fullscreen
