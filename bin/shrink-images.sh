#!/bin/bash

dir=$(dirname $1)
mkdir "$dir/low_rez"
for image in $@
do
        convert "$image" -rotate 90 -resize 1000x -quality 70 "${dir}/low_rez/low_rez_$(basename "$image")"
done
