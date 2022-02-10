#!/bin/bash

MTP_MOUNTPOINT="/run/user/1000/gvfs"
USB_MOUNTPOINT="/run/media/$user"

TTY="$(tty)"

if [ "$TTY" = "not a tty" ]
then
    MOUNTED_SYM="✓"
    UNMOUNTED_SYM="✗"
else
    MOUNTED_SYM="m"
    UNMOUNTED_SYM="u"
fi


NOTIFY_CMD='notify-send '"$(basename $0)"
notify() {
    if [ "$TTY" = "not a tty" ]
    then
        $NOTIFY_CMD "$@"
    else
        echo "$@"
    fi
}

dmenu-select() {
    if [ "$TTY" = "not a tty" ]
    then
        dmenu -i -l 20 -p '(un)mount device'
    else
        smenu -ws $'\n' -ls 'SPACE' -d -m '(un)mount device'
    fi
}


get-mount-location() {
    echo $1 | sed 's/.* (\(.\+\))/\1/'
}

set-mount-status() {
    # replace '(?)' to indicate if a device is already mounted or not
    case "$1" in 
        "mtp") while read selection; do
                location="$(get-mount-location "$selection")"
                gio info "mtp://[usb:$location]" &>/dev/null
                if [ $? -eq 0 ]; then
                    echo $selection | sed "s#(?)#($MOUNTED_SYM)#"
                else
                    echo $selection | sed "s#(?)#($UNMOUNTED_SYM)#"
                fi
            done < /dev/stdin ;;
        "usb") while read selection; do
                location="$(get-mount-location "$selection")"
                mount | grep -E "^$location" &>/dev/null
                if [ $? -eq 0 ]; then
                    echo $selection | sed "s#(?)#($MOUNTED_SYM)#"
                else
                    echo $selection | sed "s#(?)#($UNMOUNTED_SYM)#"
                fi
            done < /dev/stdin ;;
    esac
}

mount-list() {
    # get a list of USB and MTP devices
    lsusb \
        | grep '(MTP)' \
        | sed 's#Bus \(...\) Device \(...\).*:.... \(.*\) (MTP)#MTP(?)    \3 (\1:\2)#' \
        | set-mount-status mtp
    # lsblk -o PATH,LABEL,SIZE \
    lsblk -o PATH,SIZE,LABEL \
        | grep -E '/dev/sd[b-z][0-9]+|/dev/mmcblk0p[0-9]+' \
        | sed 's#\(/[^ ]*[0-9]\+\) \+\([^ ]\+\) \+\(.*\)#USB(?)    \3 [\2] (\1)#' \
        | set-mount-status usb
}

mount-select() {
    # mount or unmount selected device
    selection="$(mount-list | dmenu-select)"
    location="$(get-mount-location "$selection")"
    case "$(echo $selection | awk '{print $1}')" in
        "MTP($MOUNTED_SYM)")    gio mount -u "mtp://[usb:$location]"        && notify "Unmounted $location" ;;
        "MTP($UNMOUNTED_SYM)")  gio mount "mtp://[usb:$location]"           && notify "Mounted $location" ;;
        "USB($MOUNTED_SYM)")    udisksctl unmount -b "$location" >/dev/null && notify "Unmounted $location" ;;
        "USB($UNMOUNTED_SYM)")  udisksctl mount -b "$location" >/dev/null   && notify "Mounted $location" ;;
    esac
}


mount-select
