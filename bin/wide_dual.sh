#!/bin/sh

autorandr --load wide_dual
feh --bg-fill /home/stephen/Pictures/wallpapers/horizontal_mtn.jpg /home/stephen/Pictures/wallpapers/horizontal_mtn.jpg
killall conky
sleep 0.5
conky
