#!/bin/sh

# docked dual
autorandr --load laptop_left_of_external
feh --bg-fill /home/stephen/Pictures/wallpapers/horizontal_mtn.jpg

killall conky
sleep 0.5
conky
