#!/usr/bin/bash
# we - Watch Episode

if [[ "$1" =~ ^[0-9]+$ ]]
then
    START="$1"
    shift
fi

MPV_FLAGS="
    --fs
    --resume-playback-check-mtime
    --input-conf=""$HOME/.config/mpv/watch-episode-input.conf""
    --save-position-on-quit
    --write-filename-in-watch-later-config
    --watch-later-directory=.
    "

ENTRIES="$(ls -1Qvb -- *.mp4 *.mkv)"

if [ -n "$START" ];
then
    START_INDEX="$(echo "$ENTRIES" | cat -n | grep -P "ep0{0,3}${START}_|Episode.*?${START}\.|^\s*\d+\s+0+${START}\.|episode-${START}-|EP.${START}|- 0*${START} " | awk '{print $1 - 1}')"
    if [ -z "$START_INDEX" ]
    then
        echo "Episode $START does not exist."
        exit 1
    fi
    mpv "$@" $MPV_FLAGS --playlist-start="$START_INDEX" -- $ENTRIES
else
    mpv "$@" $MPV_FLAGS -- $ENTRIES
fi
