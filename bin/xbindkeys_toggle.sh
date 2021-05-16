#!/bin/bash

pgrep xbindkeys > /dev/null &&
  killall xbindkeys ||
    xbindkeys
