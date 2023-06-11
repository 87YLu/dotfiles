#!/bin/bash

case $INFO in
"App Store")
    ICON=
    ;;
"CleanMyMac X")
    ICON=󰇄
    ;;
"Code")
    ICON=󰨞
    ;;
"Dash")
    ICON=󰯴
    ;;
"Downie 4")
    ICON=󱑢
    ;;
"Google Chrome")
    ICON=
    ;;
"iTerm2")
    ICON=
    ;;
"Safari浏览器")
    ICON=
    ;;
"Typora")
    ICON=󰬛
    ;;
"Microsoft Outlook")
    ICON=󰴢
    ;;
"Movist Pro")
    ICON=󰎁
    ;;
"哔哩哔哩")
    ICON=󰯮
    ;;
"访达")
    ICON=󰀶
    ;;
"飞书")
    ICON=󱗆
    ;;
"图书")
    ICON=󱓷
    ;;
"网易云音乐")
    ICON=
    ;;
"微信")
    ICON=
    ;;
"系统设置")
    ICON=
    ;;
*)
    ICON=
    ;;
esac

sketchybar --set $NAME icon=$ICON
sketchybar --set $NAME.name label="$INFO"
