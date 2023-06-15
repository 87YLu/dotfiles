#!/bin/bash

source "$HOME/.config/sketchybar/plugins/weather_token.sh"

LOCATION="$(shortcuts run "Get Location" -i - | tee)"

WEATHER_JSON=$(curl -s "$WEATHER_API/current.json?key=$WEATHER_TOKEN&q=$LOCATION&lang=zh")

CITY=$(echo $WEATHER_JSON | jq '.location.name' | tr -d '"')

# Fallback if empty
if [ -z $WEATHER_JSON ]; then

    sketchybar --set $NAME label=Guangzhou
    sketchybar --set $NAME.moon icon=

    return
fi

TEMPERATURE=$(echo $WEATHER_JSON | jq '.current.temp_c' | tr -d '"')

WEATHER_DESCRIPTION=$(echo $WEATHER_JSON | jq '.current.condition.text' | tr -d '"')

MOON_JSON=$(curl -s "$WEATHER_API/astronomy.json?key=$WEATHER_TOKEN&q=$LOCATION")

MOON_PHASE=$(echo $MOON_JSON | jq '.astronomy.astro.moon_phase' | tr -d '"')

case ${MOON_PHASE} in
"New Moon")
    ICON=
    ;;
"Waxing Crescent")
    ICON=
    ;;
"First Quarter")
    ICON=
    ;;
"Waxing Gibbous")
    ICON=
    ;;
"Full Moon")
    ICON=
    ;;
"Waning Gibbous")
    ICON=
    ;;
"Last Quarter")
    ICON=
    ;;
"Waning Crescent")
    ICON=
    ;;
esac

sketchybar --set $NAME label="$CITY $TEMPERATURE"°C" $WEATHER_DESCRIPTION"
sketchybar --set $NAME.moon icon=$ICON
