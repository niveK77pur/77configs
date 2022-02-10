#!/bin/bash

# Control basic functionalities of the system through dmenu using this script

#~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
#                                   Functions
#~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

dmenu-select() {
    prompt="$1"
    shift
    echo cancel $@ | tr " " "\n" | dmenu -p "$prompt"
}

# getInfo() (
#     notify-send \
#         "Brightness: $(xbacklight)\n$(\
#         amixer -D pulse sget Master \
#         | awk -F ' ' '$6 == "[on]" || $6 == "[off]" {print "Volume " $1 " " $2 " " $5 " " $6}'\
#         )\n$(\
#         upower -i /org/freedesktop/UPower/devices/battery_BAT0| grep -E "state|percentage"
#         )"
# )

controlBrightness() (
    value=$(dmenu-select "Brightness" {1..9} 0)
    if [ "$value" = "cancel" ]; then
        exit
    elif [ "$value" -ge 0 -a "$value" -le 9 ]; then
        case "$value" in
            0) xbacklight -set 100 ;;
            *) xbacklight -set $((10 * $value)) ;;
        esac
    elif [ "$value" -ge 10 -a "$value" -le 100 ]; then
        xbacklight -set "$value"
    else
        notify-send "Invalid screen brightness: $value"
    fi
)

controlVolume() (
    value=$(dmenu-select "Volume" mute unmute toggle {1..9} 0)
    if [ "$value" = "cancel" ]; then
        exit
    elif [ "$value" = "mute" ]; then
        amixer -qD pulse sset Master mute
    elif [ "$value" = "unmute" ]; then
        amixer -qD pulse sset Master unmute
    elif [ "$value" = "toggle" ]; then
        amixer -qD pulse sset Master toggle
    elif [ "$value" -ge 0 -a "$value" -le 9 ]; then
        case "$value" in
            0) amixer -qD pulse sset Master 100% ;;
            *) amixer -qD pulse sset Master $((10 * $value))% ;;
        esac
    elif [ "$value" -ge 10 -a "$value" -le 100 ]; then
        amixer -qD pulse sset Master ${value}%
    else
        notify-send "Invalid volume: $value"
    fi
)

controlState() (
    value=$(dmenu-select "State" poweroff reboot suspend)
    case "$value" in
        poweroff|reboot) systemctl "$value" ;;
        suspend) /opt/i3lockmore/i3lockmore --image-fill "/home/kuni/Pictures/i3wallpapers/lockscreen/ludens-1576411224708-9031.jpg" \
            && systemctl suspend ;;
    esac
)


#~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
#                                 Main program
#~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

functionality=$(dmenu-select "system ops" info brightness volume state)

case "$functionality" in
    cancel)     exit 0 ;;
    info)       $HOME/bin/sysinfo.sh ;;
    brightness) controlBrightness ;;
    volume)     controlVolume ;;
    state)      controlState ;;
    *)          notify-send "Invalid system operation: $functionality" ;;
esac
