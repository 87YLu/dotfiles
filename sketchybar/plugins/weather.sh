#!/bin/bash

WEATHER_API=$(cat -s $HOME/.config/sketchybar/json/weather_api.json | jq .api | tr -d '"')

WEATHER_TOKEN=$(cat -s $HOME/.config/sketchybar/json/weather_api.json | jq .token | tr -d '"')

LOCATION=$(shortcuts run "Get Location" -i - | tee)

if [ $LOCATION == null ]; then
	LOCATION="23.13,113.27" # Guangzhou
fi

WEATHER_JSON=$(curl -s "$WEATHER_API/current.json?key=$WEATHER_TOKEN&q=$LOCATION&lang=zh")

CITY=$(echo $WEATHER_JSON | jq .location.name | tr -d '"')

CITY_ZH=$(cat $HOME/.config/sketchybar/json/location.json | jq .$CITY | tr -d '"')

TEMPERATURE=$(echo $WEATHER_JSON | jq .current.temp_c | tr -d '"')

WEATHER_DESCRIPTION=$(echo $WEATHER_JSON | jq .current.condition.text | tr -d '"')

MOON_JSON=$(curl -s "$WEATHER_API/astronomy.json?key=$WEATHER_TOKEN&q=$LOCATION")

MOON_PHASE=$(echo $MOON_JSON | jq .astronomy.astro.moon_phase | tr -d '"')

case ${MOON_PHASE} in
'New Moon')
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

sketchybar --set $NAME label="$CITY_ZH $TEMPERATURE"°C" $WEATHER_DESCRIPTION"
sketchybar --set $NAME.moon icon=$ICON
