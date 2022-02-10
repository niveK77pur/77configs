#!/bin/bash

# https://github.com/google/xsecurelock/issues/92
export XSECURELOCK_NO_COMPOSITE=1
export XSECURELOCK_SAVER=~/.config/xsecurelock/saver_feh
xsecurelock
