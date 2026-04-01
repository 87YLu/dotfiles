#!/bin/bash

dir=$(dirname "$0")
parent_dir=$(dirname $dir)
path=$parent_dir/backgrounds_path.sh
last_file=$parent_dir/.last_file

if [ ! -e "$path" ]; then
  exit 1
fi

if [ ! -e "$last_file" ]; then
  touch "$last_file"
  echo 0 >$last_file
fi

source $path

files=("$backgrounds_path"/*)

if [ ${#files[@]} -eq 0 ]; then
  exit 1
fi

last_file_index="$(cat $last_file)"

if [ "$(($last_file_index + 1))" -gt "${#files[@]}" ]; then
  last_file_index=0
fi

file=${files[last_file_index]}

echo $(($last_file_index + 1)) >$last_file

for sock in /tmp/mykitty-*; do
  [ -S "$sock" ] && /Applications/kitty.app/Contents/MacOS/kitty @ --to unix:"$sock" set-background-image "$file"
done
