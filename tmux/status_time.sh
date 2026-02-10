#!/usr/bin/env sh

# Output a clock icon (1-12) plus date/time.
# Uses local time via `date` to keep rendering simple.

hour_12=$(date +%I)
case "$hour_12" in
01) icon='󱑋' ;;
02) icon='󱑌' ;;
03) icon='󱑍' ;;
04) icon='󱑎' ;;
05) icon='󱑏' ;;
06) icon='󱑐' ;;
07) icon='󱑑' ;;
08) icon='󱑒' ;;
09) icon='󱑓' ;;
10) icon='󱑔' ;;
11) icon='󱑕' ;;
12) icon='󱑖' ;;
*) icon='󱑖' ;;
esac

printf "%s %s\n" "$icon" "$(date +%Y-%m-%d\ %H:%M)"
