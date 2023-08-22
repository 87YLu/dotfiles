#!/bin/bash

folder="$HOME/dotfiles/iTerm2/background"
files=("$folder"/*)

if [ ${#files[@]} -eq 0 ]; then
	exit 1
fi

last_file="$HOME/dotfiles/iTerm2/.last_file"

if [ ! -e "$last_file" ]; then
	touch "$last_file"
fi

last_file_path="$(cat $last_file)"
files=("${files[@]//$last_file_path/}")

if lsappinfo -all list | grep -q "iTerm2" >>/dev/null; then
	random_file_path=""

	while [ -z "$random_file_path" ]; do
		random_file_path="${files[RANDOM % ${#files[@]}]}"
	done

	echo "$random_file_path" >$last_file

	osascript -e "tell application \"iTerm\"" \
		-e "tell current session of current window" \
		-e "set background image to \"$random_file_path\"" \
		-e "end tell" \
		-e "end tell"
fi
