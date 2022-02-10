#!/bin/bash

hw_ratio=1.4143
width=1000
h=$(echo "$width * $hw_ratio" | bc)
height=${h%.*}

check_rotate() {
        if [[ $2 -gt $3 ]]
        then
                convert "$1" -rotate 90 "$1"
        fi
}

convert_to_paper() {
        size=$(convert "$1" -format "%w %h" info:)
        check_rotate "$1" $size
        convert "$1" -resize ${width}x${height} -fill white "low_rez_$1"
        convert -size ${width}x${height} -quality 0 canvas:white paper.background.jpg
        composite "low_rez_$1" paper.background.jpg -gravity center "a4_$1"
        rm "low_rez_$1" paper.background.jpg
}

shrink_to_width() {
        size=$(convert "$1" -format "%w %h" info:)
        check_rotate "$1" $size
        convert "$1" -resize ${width}x "low_rez_$1"
}

for image in $@
do
        #convert_to_paper "$image"
        shrink_to_width "$image"
done
