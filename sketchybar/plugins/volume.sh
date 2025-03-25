#!/bin/bash

case ${INFO} in
0)
	ICON=""
	ICON_PADDING_RIGHT=21
	;;
[0-9])
	ICON=""
	ICON_PADDING_RIGHT=12
	;;
*)
	ICON=""
	ICON_PADDING_RIGHT=6
	;;
esac

sketchybar --set $NAME icon=$ICON icon.padding_right=$ICON_PADDING_RIGHT label="$INFO%"

sketchybar --add item volume right \
	--set volume \
	icon.color=0xff8aadf4 \
	label.drawing=true \
	--subscribe volume volume_change
