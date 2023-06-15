#!/bin/bash

case $INFO in
"Acrobat Pro DC")
    ICON=
    ;;
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
"FaceTime通话")
    ICON=󰺙
    ;;
"Google Chrome")
    ICON=
    ;;
"iTerm2")
    ICON=
    ;;
"Permute 3")
    ICON=󰚩
    ;;
"Photoshop CC")
    ICON=
    ;;
"Safari浏览器")
    ICON=
    ;;
"Sigil")
    ICON=󰰡
    ;;
"Sublime Text")
    ICON=󱞏
    ;;
"Typora")
    ICON=󰰤
    ;;
"MarginNote 3")
    ICON=󰺿
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
"活动监视器")
    ICON=
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
