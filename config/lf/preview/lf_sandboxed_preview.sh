#!/bin/bash
# https://github.com/gokcehan/lf/wiki/Previews#sandboxing-preview-operations

set -euo pipefail
(
    exec bwrap \
     --ro-bind /usr/bin /usr/bin \
     --ro-bind /usr/share/ /usr/share/ \
     --ro-bind /usr/lib /usr/lib \
     --ro-bind /usr/lib64 /usr/lib64 \
     --symlink /usr/bin /bin \
     --symlink /usr/bin /sbin \
     --symlink /usr/lib /lib \
     --symlink /usr/lib64 /lib64 \
     --proc /proc \
     --dev /dev  \
     --ro-bind /etc /etc \
     --ro-bind ~/.config ~/.config \
     --ro-bind ~/.cache ~/.cache \
     --ro-bind "$PWD" "$PWD" \
     --unshare-all \
     --new-session \
     bash ~/.config/77configs/config/lf/preview/preview.sh "$@"
)
