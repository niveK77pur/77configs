#!/bin/bash

for item in *~
do
        #[[ "$item" = '*~' ]] && echo "No backup-files found." && exit 1
        [[ ! -e "$item" ]] && echo "No backup-files found." && exit 1
        read -n1 -p "Do you want to remove '$item'? (y/n) " CHOICE
        echo
        case $CHOICE in
                [yY])   echo "Removing '$item'"; rm "$item" ;;
                [nN])   echo "Not removing '$item'" ;;
                *)      echo "Invalid answer! Not removing '$item'" ;;
        esac
done
