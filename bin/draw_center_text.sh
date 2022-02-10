#!/bin/bash
START=`echo -e "\e(0"`
END=`echo -e "\e(B"`
COLUMNS=$(tput cols)
MES="($1)"

echo "$START"
for ((i=0;i<$COLUMNS/2-${#MES}/2;i++))
do
        echo -n "q"
done
echo -n "$END"

echo -n "$MES"

echo -n "$START"
for ((i=0;i<$COLUMNS-$COLUMNS/2+${#MES}/2-${#MES};i++))
do
        echo -n "q"
done
echo "$END"
