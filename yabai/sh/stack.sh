#!/usr/bin/env bash

isStack=$(yabai -m query --windows --window | jq '."stack-index"')

if [ $isStack -eq 0 ]; then
	windowId=$(yabai -m query --windows --window | jq -r '.id')
	# Priority is given to stacking with the top or bottom window
	# followed by stacking with the left and right windows
	yabai -m window north --stack $windowId ||
		yabai -m window south --stack $windowId ||
		yabai -m window west --stack $windowId ||
		yabai -m window east --stack $windowId
else
	yabai -m window --toggle float && yabai -m window --toggle float
fi
