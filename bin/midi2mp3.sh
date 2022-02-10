#!/bin/bash

timidity -Ow -o - "$1" | lame - "${1%midi}mp3"
