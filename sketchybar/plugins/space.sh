#!/bin/bash

SPACE_ICONS=("1" "2" "3" "4" "5" "6" "7" "8" "9")
sid=0
spaces=()

for i in "${!SPACE_ICONS[@]}"; do
    sid=$(($i + 1))

    space=(
        space.$sid
        associated_space=$sid
        icon=${SPACE_ICONS[i]}
        icon.padding_left=15
        icon.padding_right=15
        icon.highlight_color=0xffE48FA8
        background.drawing=on
        label.drawing=off
        click_script="yabai -m space --focus $sid"
    )

    sketchybar --add space space.$sid left \
        --set space.$sid "${space[@]}" \
        --subscribe space.$sid mouse.clicked
done
