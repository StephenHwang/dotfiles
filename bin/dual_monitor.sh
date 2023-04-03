#!/bin/sh
# feh --bg-fill /home/stephen/Pictures/wallpapers/horizontal_mtn.jpg /home/stephen/Pictures/wallpapers/horizontal_mtn.jpg /home/stephen/Pictures/wallpapers/vertical_mtn.jpg
# feh --bg-fill /home/stephen/Pictures/wallpapers/horizontal_mtn.jpg /home/stephen/Pictures/wallpapers/horizontal_mtn.jpg /home/stephen/Pictures/wallpapers/vertical_mtn.jpg /home/stephen/Pictures/wallpapers/horizontal_mtn.jpg

# updated naming, with 3 monitors
# feh --bg-fill /home/stephen/Pictures/wallpapers/vertical_mtn.jpg /home/stephen/Pictures/wallpapers/vertical_mtn.jpg /home/stephen/Pictures/wallpapers/horizontal_mtn.jpg

touchpad_device_id=$(xinput list | grep "Synaptics" | sed 's/.*id=//' | cut -f1)
eval "xinput enable $touchpad_device_id"

# docked dual
autorandr --load docked
feh --bg-fill /home/stephen/Pictures/wallpapers/horizontal_mtn.jpg /home/stephen/Pictures/wallpapers/vertical_mtn.jpg

killall conky
sleep 0.5
conky
