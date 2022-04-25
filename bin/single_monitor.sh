#!/bin/sh
xrandr --output HDMI-2 --off --output HDMI-1 --off --output DP-1 --off --output eDP-1 --primary --mode 1920x1080 --pos 0x840 --rotate normal --output DP-2 --off
killall conky
conky
feh --bg-fill /home/stephen/Pictures/wallpapers/horizontal_mtn.jpg

eval "xinput enable $(xinput list | grep "Synaptics" | sed 's/.*id=//' | cut -f1)"
