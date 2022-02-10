#!/bin/bash

# check whether 'youtube-dl' is installed. If not program is terminated.
[[ -e $(which youtube-dl) ]] || { echo "'youtube-dl' is not installed. This program makes use of it, so you have to install it!"; exit 1; }

browser=nautilus                # Deafult browser
msc=~/Music/Youtube_Music/      # Default working directory for this program
dllist="$msc"downloadlist.csv   # File to which a download log is being saved to
                                #+Format: Title; URL

# If the directory specified in $msc doesn't exist create it.
[[ -d "$msc" ]] || { mkdir "$msc"; echo "$msc did not exist. Creating this directory for this program to operate in."; }

dirhere(){
        default_msc="$msc"
        msc="`pwd`/"
        dllist="${msc}${dllist##"$default_msc"}"
}

download()(                     # Function that downloads mp3 versions of the video to $msc
url="$1"
cd "$msc"

[[ -f "$dllist" ]] || { echo "Info: There is no download log file available ($dllist). Creating it."; touch "$dllist"; }
# Write downloads to a file. Useful if you delete music or just want to easily find it back.
#+check if the specified link has already been downloaded and/or is already stored in $msc
namemp4=$(youtube-dl -o "%(title)s.%(ext)s" --get-filename "$url")   # Get filename from youtube-dl
namepure="${namemp4%.*}"                # Get filename without extension
filename="${namepure}.mp3"              # Add .mp3 as the new file extension
filecheck=$(ls "$msc"|fgrep "$filename")        # Check for $filename in $msc
fgrep "$url" "$dllist" > /dev/null    # Check for URL in $dllist (0 = True, 1 = False)
if [ $? = 0 ]; then             # URL is in $dllist
        echo -e "\nThe song with the specified URL has already been downloaded once."
        if [[ "$filename" = "$filecheck" ]]; then
                # Check if $filename exists in $msc
                echo "This song is already stored in $msc"
                echo
                echo "File to download:   $filename"
                echo "Stored file:        $filecheck"
                echo
                echo "This song will not be downloaded again."
                exit 1
        else
                echo "This song is currently not stored in $msc"
        fi
else                            # URL is not in $dllist
        if [[ "$filename" = "$filecheck" ]]; then
                echo -e "\nThis song is already stored in $msc"
                echo "This song will not be downloaded again."
                echo "$filename; "$url"" >> $dllist
                echo "Song written to $dllist"
                exit 2
        else
                echo "$filename; "$url"" >> "$dllist"
                echo -e "\nDownload written to $dllist"
        fi
fi

echo -e "Downloading to $(pwd)\n"
# -s, --simulate       Don't download and don't write anything to the disk
youtube-dl --extract-audio --audio-format mp3 -o "%(title)s.%(ext)s" "$url"

exit 0
)

musicin(){                      # Function that lists out stored music in $msc
cd "$msc"

echo -e "Checking for music in $(pwd)\n"
ls *mp3 | fgrep -i --color=always "$1"
#basename -a "$(ls "$msc"*mp3 | fgrep -i --color=always "$1")"
#ls "$msc"*mp3 | fgrep -i --color=always "$1" | xargs -0 basename -a

echo ""
}

playc(){                        # funtion that plays given music in $msc with cvlc
[[ -e $(which cvlc) ]] || { echo "'cvlc' is not installed. You might have to install 'vlc' to use it."; exit 1; }
echo "playing:"
ls "$msc"*mp3 | fgrep -i --color=always "$1"
echo ""
echo -e "If you shouldn't hear anything, it's very likely that the volume\nis for some reason too low. Try changing the volume in vlc."
find "$msc"*mp3 -iname "*$1*" -print0 | xargs -0 cvlc --random --play-and-exit  #Using "xargs"
#find "$msc" -iname "*$1*" -exec cvlc --random --play-and-exit {} \;        #Using find's "-exec"
}

openloc(){
echo "Opening $msc in a file browser."
[[ -e $(which nautilus) ]] || { echo "'nautilus' is not installed. This program uses nautilus as the filebrowser.\n\
        You can either try to install 'nautilus' or preferrably change the\n\
        browser used by altering the variable at the top of the source code.\n\
        You might have to alter a line in the 'openloc' function\n\
        inside $0\n\
        Search for these lines of code:\n\
        \t browser=nautilus\n\
        \t \$browser \"\$msc\" > /dev/null"; exit 1; }
$browser "$msc" > /dev/null
}

listdl(){
# colors from:
# https://www.reddit.com/r/linux/comments/qagsu/easy_colors_for_shell_scripts_color_library/
orange=`echo -en "\e[33m"`
dim=`echo -en "\e[2m"`
normal=`echo -en "\e[0m"`

case $1 in
        "d"|"del")      #  list deleted music alongside it's url (music that is in $dllist but not in $msc)
                cat "$dllist" \
                | fgrep --color=never -v "$(ls "$msc")"\
                | sort -f\
                | awk -F';' -v orange=${orange} -v dim=${dim} -v normal=${normal} '{printf "%s\n    %s%s%s%s\n",$1,dim,orange,$2,normal}'\
                | less -R
                ;;
        "l"|"link")     #  list music that is stored in $msc alongside it's url
                cat $dllist\
                | fgrep --color=never "$(ls "$msc" | sort -f)"\
                | awk -F';' -v orange=${orange} -v dim=${dim} -v normal=${normal} '{printf "%s\n    %s%s%s%s\n",$1, dim, orange,$2,normal}'\
                | less -R
                ;;
        "m"|"miss")     #  list music that has missing link (music that is stored in $msc but not in $dllist)
                ls "$msc"*mp3\
                | fgrep --color=never -v "$(cut -d';' -f1 $dllist)"\
                | less
                ;;
        "n"|"name")     #  list the names of downloaded music in $dllist
                cut -d";" -f1 $dllist\
                | sort -f\
                | less
                ;;
        "s"|"stor")     #  list the names of musics that are stored in $msc
                #ls "$msc" | less
                find "$msc" -name "*mp3" -print0 | xargs -0 basename -a | less
                ;;
        "u"|"url")      #  list the names and url of downloaded music in $dllist
                sort -f $dllist\
                | awk -F';' -v orange=${orange} -v dim=${dim} -v normal=${normal} '{printf "%s\n    %s%s%s%s\n",$1, dim, orange,$2,normal}'\
                | less -R
                ;;
        "h"|"help")
                echo -e "Quick help about the diffrent listing options:"
                printf "   -l%c, -l%s\t\t%s\n" d del  "List deleted music alongside its URL."
                printf "   -l%c, -l%s\t\t%s\n" l link "List music that is stored in $msc alongside its url (if not available, music won't be listed)."
                printf "   -l%c, -l%s\t\t%s\n" m miss "List music that has a missing link, so no saved URL. "
                printf "   -l%c, -l%s\t\t%s\n" n name "List the names of music that have been downloaded (saved in $dllist)."
                printf "   -l%c, -l%s\t\t%s\n" s stor "List the names of music that are stored in $msc"
                printf "   -l%c, -l%s\t\t%s\n" u url  "List the names of music alongside their URLs that have been downloaded (saved in $dllist)." ;;
        ?) echo "Wrong option. Use -lh to get help about the diffrent listing options." ;;
esac
}

copymsc(){                      # Function that synchronizes $msc with the specified path
[[ -e $(which nautilus) ]] || { echo "'nautilus' is not installed. This program uses nautilus as the filebrowser.\n\
        You can either try to install 'nautilus' or preferrably change the\n\
        browser used by altering the variable at the top of the source code.\n\
        You might have to alter a line in the 'copymsc' function\n\
        inside $0\n\
        Search for these lines of code:\n\
        \t browser=nautilus\n\
        \t \$browser \"\$dircp\" \"\$1\" 2> /dev/null"; exit 1; }

read -p "Do you want to copy all the music into '$1' (y/n)? " choice
case "$choice" in
        [yY] | [yY][eE][sS])
                #rsync -hi "$msc"*mp3 "$1"
                #echo "Synchronizing complete."
                pccont=/tmp/music_pc_content.txt
                dicont=/tmp/music_diff_content.txt
                dircp=/tmp/music_copy/

                find "$msc" -maxdepth 1 -name "*.mp3" -exec basename {} \; | sort > "$pccont"
                find "$1" -type f -exec basename {} \; | sort | comm -32 "$pccont" - > "$dicont"
                mkdir "$dircp"

                while read file
                do
                        cp "${msc}${file}" "$dircp"
                        echo -n "."
                done < "$dicont"
                echo Done copying into "$dircp"

                echo -e "\nDrag music from '$dircp' into '$1'"
                $browser "$dircp" "$1" 2> /dev/null

                ans='n'
                until [[ $ans = 'y' ]]
                do
                        read -n1 -p "Are you done copying? (y/n) " ans
                        echo
                done
                rm -rf "$pccont" "$dicont" "$dircp"
                ;;
        [nN] | [nN][oO])
                echo "Not copying anything."
                ;;
        *)      echo "Invalid answer. Not copying anything." ;;
esac

}

playall(){
[[ -e $(which nvlc) ]] || { echo "'nvlc' is not installed. You might have to install 'vlc' to use it."; exit 1; }
nvlc --random "$msc"*mp3
}

cmdhelp(){                      # Function that outputs a help section
# \e[4m   underline text
# \e[0m   reset text to normal
echo -e "Usage:  $(basename $0) [-d] \e[4mURL\e[0m"
echo -e "        $(basename $0) [-d] [-ps] \e[4msearch pattern\e[0m"
echo -e "        $(basename $0) [-d] [-c] \e[4mdestination\e[0m"
echo -e "        $(basename $0) [-d] [-aloh]"
echo
echo "Default working directory for this program: $msc"
printf "      \t%s\n"   "Entering a URL without options will download an mp3 version of the youtube video"
printf "   -%c\t%s\n" a "Play all the music that is stored in the directory"
printf "   -%c\t%s\n" c "Synchronize directory with a specified location"
printf "   -%c\t%s\n" d "The specified action will be performed in the current directory!"
printf "   -lh\t%s\n"   "Get help about the different listing options." #List songs. Use -lh to get help about the diffrent listing options."
printf "   -%c\t%s\n" o "Open directory in a file browser"
printf "   -%c\t%s\n" p "Search and play items with a given pattern"
printf "   -%c\t%s\n" s "Search for items with a given pattern"
printf "   -%c\t%s\n" h "Display this help section and exit"
}


if [ $# -eq 0 ]; then
        echo "No arguments. Use -h to display help."
        exit 1
else
        s_do=1
        h_do=1
        p_do=1
        o_do=1
        l_do=1
        c_do=1
        a_do=1
        d_do=1
        while getopts s:hp:ol::c:ad opt 2>/dev/null
        do
                case $opt in
                        s) s_do=0; s_oa="$OPTARG"       #musicin "$OPTARG"; exit 0
                           # search
                           ;;
                        h) h_do=0                       #cmdhelp; exit 0
                           # help
                           ;;
                        p) p_do=0; p_oa="$OPTARG"       #playc "$OPTARG"; exit 0
                           # play
                           ;;
                        o) o_do=0                       #openloc; exit 0
                           # open
                           ;;
                        l) l_do=0; l_oa="$OPTARG"       #listdl "$OPTARG"; exit 0
                           # list
                           ;;
                        c) c_do=0; c_oa="$OPTARG"       #copymsc "$OPTARG"; exit 0
                           # copy
                           ;;
                        a) a_do=0                       #playall; exit 0
                           # play all music
                           ;;
                        d) d_do=0                       #download "$OPTARG" 'sOme_RandOm_STrinG'; exit 0
                           # operate in current dir
                           ;;
                        ?) #echo "($0): An error occured during getopts."
                           echo "Invalid option: $1"
                           echo "Use -h to display help."
                           exit 2
                           ;;
                esac
        done
        [ $d_do -eq 0 ] && dirhere
        [ $h_do -eq 0 ] && cmdhelp         && exit 0
        [ $s_do -eq 0 ] && musicin "$s_oa" && exit 0
        [ $p_do -eq 0 ] && playc   "$p_oa" && exit 0
        [ $o_do -eq 0 ] && openloc "$o_oa" && exit 0
        [ $l_do -eq 0 ] && listdl  "$l_oa" && exit 0
        [ $c_do -eq 0 ] && copymsc "$c_oa" && exit 0
        [ $a_do -eq 0 ] && playall "$a_oa" && exit 0
        [ $1 = -d ] && download "$2" || download "$1"
fi
