#!/bin/bash

floating=$(echo $(yabai -m query --windows --window | jq '."is-floating"'))

if [[ $floating = true ]]; then
	sketchybar --set $NAME.name label="$INFO 󰉪"
else
	sketchybar --set $NAME.name label="$INFO"
fi

ICON=$(cat $HOME/.config/sketchybar/json/icon.json | jq '.["'"$INFO"'"]' | tr -d '"')

if [ $ICON == null ]; then
	ICON=$(cat $HOME/.config/sketchybar/json/icon.json | jq '.["*"]' | tr -d '"')
fi

sketchybar --set $NAME icon=$ICON
