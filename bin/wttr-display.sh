#!/bin/bash

URL='wttr.in/luxemburg'
# alacritty --class floaty --dimensions 125 39 --command less -fR <(curl -s "$URL")
alacritty --class floaty -- --command less -fR <(curl -s "$URL")

# FILE="$(mktemp)"
# curl --silent --output "$FILE" "$URL"
# alacritty --class floaty --dimensions 125 39 --command less -fR "$FILE"
# rm "$FILE"
