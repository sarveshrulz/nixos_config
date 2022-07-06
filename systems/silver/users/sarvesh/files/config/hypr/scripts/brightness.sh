#!/bin/sh

msgId="69"

xbacklight -fps 60 "$@"
curr="$(xbacklight -get)"

dunstify -a "changeBrightness" -i ~/.config/dunst/icons/brightness.png -u low -r "$msgId" "Brightness: ${curr}%"
