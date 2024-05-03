#!/usr/bin/env bash

OUTPUT=HDMI1
SCREEN=eDP1

position=$(echo "above below same-as left-of right-of off" | tr ' ' '\n' | dmenu -i -l 10 -p "Screen position")
case "$position" in
    "")     ;;
    off)    xrandr --output "$OUTPUT" --off ;;
    *)      xrandr --output "$OUTPUT" --auto "--$position" "$SCREEN" ;;
esac
