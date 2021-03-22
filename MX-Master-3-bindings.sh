#!/usr/bin/env bash

button=$1

# Identify active window
# wmctrl -l
# eg. qterminal, RStudio
# https://askubuntu.com/questions/97213/application-specific-key-combination-remapping
Wid=`xdotool getactivewindow`
Wname=`xprop -id ${Wid} |awk '/WM_CLASS/{print $4}'`

# Horizontal scroll sensitivity reduction
hScrollModulo=4
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

  "Scroll_R")
    temporizeHorizontalScroll "R"
      case "$Wname" in
        '"qterminal"')
            xte 'keydown Alt_L' 'key u' 'keyup Alt_L'; ;;
        *) xte 'keydown Control_L' 'key Tab' 'keyup Control_L'; ;;
      esac
      ;;

  "Scroll_L")
  temporizeHorizontalScroll "L"
    case "$Wname" in
      '"qterminal"')
          xte 'keydown Alt_L' 'key y' 'keyup Alt_L'; ;;
      *) xte 'keydown Control_L' 'keydown Shift_L' 'key Tab' 'keyup Shift_L' 'keyup Control_L'; ;;
    esac
  ;;

  "Alt_Scroll_R")
    xdotool key --clearmodifiers XF86AudioRaiseVolume;
  ;;

  "Alt_Scroll_L")
    xdotool key --clearmodifiers XF86AudioLowerVolume;
  ;;

esac
