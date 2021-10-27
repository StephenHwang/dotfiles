#!/bin/sh
# feh --bg-fill /home/stephen/Pictures/wallpapers/horizontal_mtn.jpg /home/stephen/Pictures/wallpapers/horizontal_mtn.jpg /home/stephen/Pictures/wallpapers/vertical_mtn.jpg
# feh --bg-fill /home/stephen/Pictures/wallpapers/horizontal_mtn.jpg /home/stephen/Pictures/wallpapers/horizontal_mtn.jpg /home/stephen/Pictures/wallpapers/vertical_mtn.jpg /home/stephen/Pictures/wallpapers/horizontal_mtn.jpg

# updated naming, with 3 monitors
# feh --bg-fill /home/stephen/Pictures/wallpapers/vertical_mtn.jpg /home/stephen/Pictures/wallpapers/vertical_mtn.jpg /home/stephen/Pictures/wallpapers/horizontal_mtn.jpg 

# docked dual
autorandr --load docked
feh --bg-fill /home/stephen/Pictures/wallpapers/horizontal_mtn.jpg /home/stephen/Pictures/wallpapers/vertical_mtn.jpg 

killall conky
sleep 0.5
conky
