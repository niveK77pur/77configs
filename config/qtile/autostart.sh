#!/bin/bash

"$HOME/bin/initscreen.sh"

ps -u "$USER" | grep dunst >/dev/null || {
    echo "Starting dunst ..."
    dunst &
}
