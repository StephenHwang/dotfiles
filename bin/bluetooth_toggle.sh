#!/bin/bash

hcitool dev | grep hci > /dev/null &&
  rfkill block bluetooth ||
    rfkill unblock bluetooth

# for disable autoswitch bluetooth profiles: (also ensure  talk-to-speak is disabled)
#     /etc/pulse/default.pa
#     load-module module-bluetooth-policy auto_switch=0
