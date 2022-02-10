#!/bin/bash 

update_newer() {
        # $1 : local file
        # $2 : external file
        if [[ -e "$2" ]]
        then
                if [[ "$1" -nt "$2" ]]
                then
                        #echo "$1 --> $2"
                        echo "$(basename "$1")(l) --> $(basename "$2")(e)"
                        rsync --update "$1" "$2"
                elif [[ "$2" -nt "$1" ]]
                then
                        #echo "$2 --> $1"
                        echo "$(basename "$2")(e) --> $(basename "$1")(l)"
                        rsync --update "$2" "$1"
                else
                        echo "up-to-date: $(basename "$1")(l) $(basename "$2")(e)"
                fi
        else
                echo "File not found: $2"
        fi
}


l_ft_pascal='/home/kevin/.vim/after/ftplugin/pascal.vim'
e_ft_pascal='/media/kevin/BIEWESCH_K/gVimPortable7.4/Data/settings/vimfiles/ftplugin/pascal.vim'

l_ft_vim='/home/kevin/.vim/after/ftplugin/vim.vim'
e_ft_vim='/media/kevin/BIEWESCH_K/gVimPortable7.4/Data/settings/vimfiles/ftplugin/vim.vim'

update_newer "$l_ft_pascal" "$e_ft_pascal"
update_newer "$l_ft_vim" "$e_ft_vim"
