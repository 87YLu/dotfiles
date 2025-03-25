#!/usr/bin/env bash

target=$1
spaces=$(yabai -m query --spaces --space last | jq .index)

if [[ $spaces -lt $target ]]; then
	for ((i = $spaces; i < $target; i++)); do
		yabai -m space --create
	done
fi

yabai -m space --focus $target
