#!/usr/bin/env bash

button=$1

# Horizontal scroll sensitivity reduction
hScrollModulo=3
hScrollIndexBuffer="/dev/shm/LogitechMXMaster3HScroll"

function temporizeHorizontalScroll {

  local newDirection=$@;

  # read buffer
  local buffer=(`cat $hScrollIndexBuffer`)
  local oldDirection=${buffer[0]}
  local value=${buffer[1]}

  if [ "$oldDirection" = "$newDirection" ]; then
    # increment
    ((value++))
    ((value%=$hScrollModulo))
  else
    # reset on direction change
    value=1
  fi

  # write buffer
  echo "$newDirection $value" > $hScrollIndexBuffer || value=0

  # temporize scroll
  [ ${value} -ne 0 ] && exit;
}


case "$button" in

  "Scroll_L")
    temporizeHorizontalScroll "L"
    # # Previous tab
    # xdotool key --clearmodifiers ctrl+shift+Tab; ;;
    xte 'keydown Control_L' 'keydown Shift_L' 'key Tab' 'keyup Shift_L' 'keyup Control_L'; ;;

  "Scroll_R")
    temporizeHorizontalScroll "R"
    #;; # Next tab
    xte 'keydown Control_L' 'key Tab' 'keyup Control_L'; ;;

  # ...

esac
