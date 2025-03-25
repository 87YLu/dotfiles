#!/usr/bin/env bash

spaceType=$(yabai -m query --spaces --space | jq .type)
app=$(echo $(yabai -m query --windows --window | jq '.app' | tr -d '"'))

floating=$(echo $(yabai -m query --windows --window | jq '."is-floating"'))

if [[ $floating = true ]]; then
	sketchybar --set front_app.name label="$app 󰉪"
else
	sketchybar --set front_app.name label="$app"
fi
