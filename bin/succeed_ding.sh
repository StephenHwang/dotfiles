#!/bin/bash

CHANNEL=11111
ncat --idle-timeout 1s localhost $CHANNEL 2>&1 | grep -v "Ncat: Idle timeout expired (1000 ms)."
echo -n ""
