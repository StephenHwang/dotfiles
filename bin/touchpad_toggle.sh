#!/bin/bash

touchpad_device_id=$(xinput list | grep "Synaptics" | sed 's/.*id=//' | cut -f1)
touchpad_status_line=$(xinput --list-props $touchpad_device_id | grep Enabled)
touchpad_status=${touchpad_status_line: -1}

if [[ $touchpad_status -eq 0 ]]
then
  eval "xinput enable $touchpad_device_id"
  echo "Enabled touchpad"
else
  eval "xinput disable $touchpad_device_id"
  echo "Disabled touchpad"
fi
