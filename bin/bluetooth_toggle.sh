#!/bin/bash

hcitool dev | grep hci > /dev/null &&
  rfkill block bluetooth ||
    rfkill unblock bluetooth

