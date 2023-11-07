#!/bin/bash

ps -u "$USER" | grep dunst >/dev/null || {
    echo "Starting dunst ..."
    dunst &
}

clipmenud &
waybar &
