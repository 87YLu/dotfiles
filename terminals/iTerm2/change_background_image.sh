#!/bin/bash

dir=$(dirname $(dirname "$0"))

path=$dir/backgrounds_path.sh

if [ ! -e "$path" ]; then
	exit 1
fi

source $path

files=("$backgrounds_path"/*)

if [ ${#files[@]} -eq 0 ]; then
	exit 1
fi

last_file="$dir/.last_file"

if [ ! -e "$last_file" ]; then
	touch "$last_file"
	echo 0 >$last_file
fi

if lsappinfo -all list | grep -q "iTerm2" >>/dev/null; then
	last_file_index="$(cat $last_file)"

	if [ "$(($last_file_index + 1))" -gt "${#files[@]}" ]; then
		last_file_index=0
	fi

	file=${files[last_file_index]}

	echo $(($last_file_index + 1)) >$last_file

	osascript -e "tell application \"iTerm\"" \
		-e "tell current session of current window" \
		-e "set background image to \"$file\"" \
		-e "end tell" \
		-e "end tell"
fi
