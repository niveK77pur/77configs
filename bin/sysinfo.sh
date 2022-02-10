#!/bin/bash

notify-send \
    --icon="/usr/share/icons/Adwaita/32x32/devices/computer-symbolic.symbolic.png"\
    "System Information"\
    "$(printf "%s\n%s\n%s" \
        "$(acpi --battery | sed 's@^\([^:]*\):\s*@\1#@')" \
        "$(echo "Brightness#$(xbacklight -get || echo ??)")" \
        "$(amixer -D pulse sget Master | awk -F " " '/\[(on|off)\]/{print "Volume " $1 " " gensub(":", "#", 1, $2) $5 " " $6}')" \
        | column -ts '#' \
    )"

# notify-send \
#     --icon="/usr/share/icons/Adwaita/32x32/devices/computer-symbolic.symbolic.png"\
#     "System Information"\
#     "$(printf "%s\n%s\n%s" \
#         "$(acpi --battery | sed 's#^\([^:]*:\)\s*#\1\t\t#')" \
#         "$(echo "Brightness:\t\t$(xbacklight -get || echo ??)")" \
#         "$(amixer -D pulse sget Master | awk -F " " '$6 == "[on]" || $6 == "[off]" {print "Volume " $1 " " $2 "\t" $5 " " $6}')" \
#         | column -ts ':' \
#     )"
