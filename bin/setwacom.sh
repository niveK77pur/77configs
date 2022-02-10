#!/bin/bash
# vim: fdm=marker

# Useful information about the tablet {{{

# $ xsetwacom list devices
# Wacom Intuos Pro M Pen stylus   	id: 12	type: STYLUS    
# Wacom Intuos Pro M Pad pad      	id: 13	type: PAD       
# Wacom Intuos Pro M Finger touch 	id: 14	type: TOUCH     
# Wacom Intuos Pro M Pen eraser   	id: 19	type: ERASER    
# Wacom Intuos Pro M Pen cursor   	id: 20	type: CURSOR    

# Buttons IDs
# $ xev -event button

# Tables layout SVG file
# (Letters correspond to numbers in xorg.confg, i.e A->1, B->2, ...)
# grep -rli "<tablet name>" /usr/share/libwacom/

#}}} 

STYLUS='Wacom Intuos Pro M Pen stylus'    
PAD='Wacom Intuos Pro M Pad pad'       
TOUCH='Wacom Intuos Pro M Finger touch'     
ERASER='Wacom Intuos Pro M Pen eraser'    
CURSOR='Wacom Intuos Pro M Pen cursor'    

# Rotate drawing area for Left-Handed
xsetwacom set "$STYLUS" Rotate half

# Adjusting aspect ratios
unset BC_ENV_ARGS # use plain 'bc'
TABLET_WIDTH=$(xsetwacom get "$STYLUS" Area | awk '{print $3}')
SCREEN_RATIO=$(xdpyinfo | awk '/dimensions/{ sub("x", "/", $2); print $2 }' | bc -l)
TABLET_HEIGHT=$( bc <<< "$TABLET_WIDTH / $SCREEN_RATIO" )
xsetwacom set "$STYLUS" Area 0 0 $TABLET_WIDTH $TABLET_HEIGHT
