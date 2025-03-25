#!/bin/bash

WEATHER_API=$(cat -s $HOME/.config/sketchybar/json/weather.json | jq .weatherApi | tr -d '"')

GEO_API=$(cat -s $HOME/.config/sketchybar/json/weather.json | jq .geoApi | tr -d '"')

MOON_API=$(cat -s $HOME/.config/sketchybar/json/weather.json | jq .moonApi | tr -d '"')

API_KEY=$(cat -s $HOME/.config/sketchybar/json/weather.json | jq .apiKey | tr -d '"')

LOCATION=$(shortcuts run "Get Location" -i - | tee)

if [ $LOCATION == "" ]; then
	LOCATION="113.17,23.8" # guangzhou
fi

SEARCH_PARAMS="?key=$API_KEY&location=$LOCATION&lang=zh"

CITY=$(echo $(curl -L -X GET --compressed $GEO_API/$SEARCH_PARAMS) | jq ".location[0].name" | tr -d '"')

WEATHER_JSON=$(curl -L -X GET --compressed $WEATHER_API/$SEARCH_PARAMS)

TEMPERATURE=$(echo $WEATHER_JSON | jq .now.temp | tr -d '"')

WEATHER_DESCRIPTION=$(echo $WEATHER_JSON | jq .now.text | tr -d '"')

MOON_PHASE=$(echo $(curl -L -X GET --compressed $MOON_API/$SEARCH_PARAMS) | jq ".daily[0].moonPhase" | tr -d '"')

ICON=$(cat -s $HOME/.config/sketchybar/json/weather.json | jq '.["'"$MOON_PHASE"'"]' | tr -d '"')

sketchybar --set $NAME label="$CITY $TEMPERATURE"°C" $WEATHER_DESCRIPTION"
sketchybar --set $NAME.moon icon=$ICON
