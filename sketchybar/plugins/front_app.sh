#!/bin/bash

ICON=$(cat -s $HOME/.config/sketchybar/json/icon.json | jq '.["'"$INFO"'"]' | tr -d '"')

if [ $ICON == null ]; then
	ICON=$(cat $HOME/.config/sketchybar/json/icon.json | jq '.["*"]' | tr -d '"')
	return
fi

sketchybar --set $NAME icon=$ICON
sketchybar --set $NAME.name label="$INFO"
