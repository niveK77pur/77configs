#!/bin/bash

dunstctl set-paused toggle
[ "$(dunstctl is-paused)" = "false" ] && notify-send --urgency=low "dunstctl" "Notifications are back on"
