#!/bin/bash

DAY_NUMBERS=("日" "一" "二" "三" "四" "五" "六")
CURRENT_DAY=$(date '+%w')

DAY=$(date '+%m月%d日')

WEEK=周${DAY_NUMBERS[$CURRENT_DAY]}

TIME=$(date '+%-H:%M')

sketchybar --set $NAME label="$DAY $WEEK $TIME"
