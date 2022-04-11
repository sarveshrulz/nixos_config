#!/bin/sh

msgId="69"

pamixer $@ > /dev/null

if [ $(pamixer --get-mute) = true ] && [ ! $@ = '-t' ]; then
     pamixer -t
fi

volume=$(pamixer --get-volume)
mute=$(pamixer --get-mute)

if [ $volume = 0 ] || [ $mute = true ]; then
    dunstify -a "changeVolume" -i ~/.config/dunst/icons/muted.png -u low -r "$msgId" "Volume: muted" 
else
    dunstify -a "changeVolume" -i ~/.config/dunst/icons/volume.png -u low -r "$msgId" "Volume: ${volume}%"
fi
