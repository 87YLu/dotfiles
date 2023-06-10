#!/usr/bin/env zsh

case $INFO in
"Code")
    ICON=󰨞
    ;;
"Calendar")
    ICON=
    ;;
"FaceTime")
    ICON=
    ;;
"Finder")
    ICON=
    ;;
"Google Chrome")
    ICON=
    ;;
"Messages")
    ICON=󰍦
    ;;
"iTerm2")
    ICON=
    ;;
*)
    ICON=﯂
    ;;
esac

sketchybar --set $NAME icon=$ICON icon.padding_right=8 icon.padding_left=6
sketchybar --set $NAME.name label="$INFO"
