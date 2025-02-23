# vim: tabstop=4
# ~/.bashrc: executed by bash(1) for non-login shells.
# see /usr/share/doc/bash/examples/startup-files (in the package bash-doc)
# for examples

# If not running interactively, don't do anything
case $- in
    *i*) ;;
      *) return;;
esac

# don't put duplicate lines or lines starting with space in the history.
# See bash(1) for more options
HISTCONTROL=ignoreboth

# append to the history file, don't overwrite it
shopt -s histappend

# for setting history length see HISTSIZE and HISTFILESIZE in bash(1)
HISTSIZE=3000
# HISTFILESIZE=4000

# check the window size after each command and, if necessary,
# update the values of LINES and COLUMNS.
shopt -s checkwinsize

# If set, the pattern "**" used in a pathname expansion context will
# match all files and zero or more directories and subdirectories.
#shopt -s globstar

# make less more friendly for non-text input files, see lesspipe(1)
[ -x /usr/bin/lesspipe ] && eval "$(SHELL=/bin/sh lesspipe)"

# set variable identifying the chroot you work in (used in the prompt below)
if [ -z "${debian_chroot:-}" ] && [ -r /etc/debian_chroot ]; then
    debian_chroot=$(cat /etc/debian_chroot)
fi

# set a fancy prompt (non-color, unless we know we "want" color)
case "$TERM" in
    xterm-color) color_prompt=yes;;
esac

# uncomment for a colored prompt, if the terminal has the capability; turned
# off by default to not distract the user: the focus in a terminal window
# should be on the output of commands, not on the prompt
force_color_prompt=yes

if [ -n "$force_color_prompt" ]; then
    if [ -x /usr/bin/tput ] && tput setaf 1 >&/dev/null; then
    # We have color support; assume it's compliant with Ecma-48
    # (ISO/IEC-6429). (Lack of such support is extremely rare, and such
    # a case would tend to support setf rather than setaf.)
    color_prompt=yes
    else
    color_prompt=
    fi
fi

# Nice tutorial on prompt customization:
# https://wiki.archlinux.org/index.php/Bash/Prompt_customization
export PROMPT_DIRTRIM=3
if [ "$color_prompt" = yes ]; then
    if [ "$(whoami)" = 'vagrant' ]; then
        PS1='${debian_chroot:+($debian_chroot)}\[\033[01;32m\]\u\[\e[35m\]@\[\e[32m\]\h\[\033[01;34m\]\w\[\033[00m\]\$ '
    elif [ "$(whoami)" = 'root' ]; then  
        PS1='\[\e[31;1m\]\u@\h:\[\e[00;31;2m\]\w\$\[\e(B\e\[m\]\] '
    else
        #PS1='${normal}${bold}${yellow}\u@\h:${normal}${purple}\w${aqua}\$ ${normal} '
        PS1='\[\e[0;1;33m\]\u@\h\[\e[0m\]:\[\e[35m\]\w\[\e[36m\]\$\[\e[0m\] '
        #PS1='\[\e[0;1;33m\]\u@\h\[\e[0m\]×\[\e[35m\]\A\[\e[36m\]\$\[\e[0m\] '
        #PS1='${debian_chroot:+($debian_chroot)}\[\033[01;32m\]\u@\h\[\033[00m\]:\[\033[01;34m\]\w\[\033[00m\]\$ '
        #PS1="\n${C1}\u@\h (${C2} \w ${C1})\$(git branch 2> /dev/null | sed -e '/^[^*]/d' -e 's/* \(.*\)/ ${C1}• ${C2}\1/')${C1} • ${C2}\$(ls -1 | wc -l | sed 's: ::g') files${C1} • ${C2}\$(ls -lah | command grep -v / | command grep -m 1 total | sed 's/total //')\n${C1}====> \[\e[0m\]"
    fi
else
    PS1='${debian_chroot:+($debian_chroot)}\u@\h:\w\$ '
fi
unset color_prompt force_color_prompt

# If this is an xterm set the title to user@host:dir
case "$TERM" in
xterm*|rxvt*)
    PS1="\[\e]0;${debian_chroot:+($debian_chroot)}\u@\h: \w\a\]$PS1"
    ;;
*)
    ;;
esac

# enable color support of ls and also add handy aliases
if [ -x /usr/bin/dircolors ]; then
    test -r ~/.dircolors && eval "$(dircolors -b ~/.dircolors)" || eval "$(dircolors -b)"
    alias ls='ls --color=auto'
    #alias dir='dir --color=auto'
    #alias vdir='vdir --color=auto'

    alias grep='grep --color=auto'
    alias fgrep='fgrep --color=auto'
    alias egrep='egrep --color=auto'
fi

# some more ls aliases
alias ll='ls -alF'
alias la='ls -A'
alias l='ls -CF'

# Add an "alert" alias for long running commands.  Use like so:
#   sleep 10; alert
alias alert='notify-send --urgency=low -i "$([ $? = 0 ] && echo terminal || echo error)" "$(history|tail -n1|sed -e '\''s/^\s*[0-9]\+\s*//;s/[;&|]\s*alert$//'\'')"'

# Alias definitions.
# You may want to put all your additions into a separate file like
# ~/.bash_aliases, instead of adding them here directly.
# See /usr/share/doc/bash-doc/examples in the bash-doc package.

if [ -f ~/.config/bash/bash_aliases ]; then
    . ~/.config/bash/bash_aliases
fi

# enable programmable completion features (you don't need to enable
# this, if it's already enabled in /etc/bash.bashrc and /etc/profile
# sources /etc/bash.bashrc).
if ! shopt -oq posix; then
  if [ -f /usr/share/bash-completion/bash_completion ]; then
    . /usr/share/bash-completion/bash_completion
  elif [ -f /etc/bash_completion ]; then
    . /etc/bash_completion
  fi
fi

#~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
#                                 My Functions
#~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

# Thunderbird ------------------------------------------------------------------
# Thunderbird must be started.
# The description can be found at the following link:
#    http://askubuntu.com/questions/5431/how-can-i-email-an-attachment-from-the-command-line
thunderbird-compose () {
    thunderbird -remote "xfeDoCommand(composeMessage,subject='$1',to='$2',body='$3',attachment='$(readlink -f "$4")')"
}


# File Managers ----------------------------------------------------------------
LFCD="$HOME/.config/lf/lfcd.sh"
if [ -f "$LFCD" ]; then
    source "$LFCD"
fi

ranger-cd() {
    tempfile="$(mktemp)"
    /usr/bin/ranger --choosedir="$tempfile" "${@:-$(pwd)}"
    test -f "$tempfile" &&
    if [ "$(cat -- "$tempfile")" != "$(echo -n `pwd`)" ]; then
        cd -- "$(cat "$tempfile")"
    fi
    rm -f -- "$tempfile"
}
##This binding has been moved to the .inputrc file
# This binds Ctrl-O to ranger-cd:
#bind '"\C-o":"ranger-cd\C-m"'

# Python -----------------------------------------------------------------------
pyvirtualenvwrapper() {
    # more python virtualenv specific commands
    source /home/kuni/.local/bin/virtualenvwrapper.sh
}


# Anaconda/Miniconda -----------------------------------------------------------

# miniconda3 installed from AUR
[ -f /opt/miniconda3/etc/profile.d/conda.sh ] && source /opt/miniconda3/etc/profile.d/conda.sh

#goconda() {
#    # >>> conda initialize >>>
#    # !! Contents within this block are managed by 'conda init' !!
#    __conda_setup="$('/home/kuni/anaconda3/bin/conda' 'shell.bash' 'hook' 2> /dev/null)"
#    if [ $? -eq 0 ]; then
#        eval "$__conda_setup"
#    else
#        if [ -f "/home/kuni/anaconda3/etc/profile.d/conda.sh" ]; then
#            . "/home/kuni/anaconda3/etc/profile.d/conda.sh"
#        else
#            export PATH="/home/kuni/anaconda3/bin:$PATH"
#        fi
#    fi
#    unset __conda_setup
#    # <<< conda initialize <<<
#}

# Miscellaneous ----------------------------------------------------------------
hr() {
    # draw line using modal terminal line-drawing characters
    # A Bash Prompts HowTo Guide
    # https://networking.ringofsaturn.com/Unix/Bash-prompts.php
    local start=$'\e(0' end=$'\e(B' line='q'
    local cols=${COLUMNS:-$(tput cols)}
    while ((${#line} < cols)); do line+="$line"; done
    printf '%s%s%s\n' "$start" "${line:0:cols}" "$end"
}

#~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
#                                 My Variables
#~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

# Colors -----------------------------------------------------------------------
# colors from:
# https://www.reddit.com/r/linux/comments/qagsu/easy_colors_for_shell_scripts_color_library/
export bold=`echo -en "\e[1m"`                  ### from this webpage
export underline=`echo -en "\e[4m"`             ###
export nounderline=`echo -en "\e[24m"`
export dim=`echo -en "\e[2m"`                   ###
export strickthrough=`echo -en "\e[9m"`         ###
export blink=`echo -en "\e[5m"`                 ###
export reverse=`echo -en "\e[7m"`               ###
export noreverse=`echo -en "\e[27m"`
export italic=`echo -en "\e[3m"`
export noitalic=`echo -en "\e[23m"`
export hidden=`echo -en "\e[8m"`                ###
export normal=`echo -en "\e[0m"`                ###
export black=`echo -en "\e[30m"`                ###
export red=`echo -en "\e[31m"`                  ###
export green=`echo -en "\e[32m"`                ###
export orange=`echo -en "\e[33m"`  #yellow      ###
export blue=`echo -en "\e[34m"`                 ###
export purple=`echo -en "\e[35m"`               ###
export aqua=`echo -en "\e[36m"`                 ###
export gray=`echo -en "\e[37m"`                 ###
export darkgray=`echo -en "\e[90m"`             ###
export lightred=`echo -en "\e[91m"`             ###
export lightgreen=`echo -en "\e[92m"`           ###
export lightyellow=`echo -en "\e[93m"`          ###
export lightblue=`echo -en "\e[94m"`            ###
export lightpurple=`echo -en "\e[95m"`          ###
export lightaqua=`echo -en "\e[96m"`            ###
export white=`echo -en "\e[97m"`                ###
export default=`echo -en "\e[39m"`              ###
export BLACK=`echo -en "\e[40m"`                ###
export RED=`echo -en "\e[41m"`                  ###
export GREEN=`echo -en "\e[42m"`                ###
export ORANGE=`echo -en "\e[43m"`               ###
export BLUE=`echo -en "\e[44m"`                 ###
export PURPLE=`echo -en "\e[45m"`               ###
export AQUA=`echo -en "\e[46m"`                 ###
export GRAY=`echo -en "\e[47m"`                 ###
export DARKGRAY=`echo -en "\e[100m"`            ###
export LIGHTRED=`echo -en "\e[101m"`            ###
export LIGHTGREEN=`echo -en "\e[102m"`          ###
export LIGHTYELLOW=`echo -en "\e[103m"`         ###
export LIGHTBLUE=`echo -en "\e[104m"`           ###
export LIGHTPURPLE=`echo -en "\e[105m"`         ###
export LIGHTAQUA=`echo -en "\e[106m"`           ###
export WHITE=`echo -en "\e[107m"`               ###
export DEFAULT=`echo -en "\e[49m"`              ###
export reset=`echo -en "\e(B\e[m"` # \e[00m

# LF icons ---------------------------------------------------------------------
[ -f "$HOME/.config/lf/icons.sh" ] && source "$HOME/.config/lf/icons.sh" 

#~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
#                               Program Settings
#~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

# Fuzzy finder -----------------------------------------------------------------
# [ -f ~/.fzf.bash ] && source ~/.fzf.bash
[ -f "${XDG_CONFIG_HOME:-$HOME/.config}"/fzf/fzf.bash ] && source "${XDG_CONFIG_HOME:-$HOME/.config}"/fzf/fzf.bash
# export FZF_DEFAULT_COMMAND="find"
export FZF_DEFAULT_COMMAND='rg --files'

# pywal ------------------------------------------------------------------------
# if xset q &>/dev/null;
# then
#     (cat ~/.cache/wal/sequences &)
# fi

# autojump/z ---------------------------------------------------------------------
# [[ -s /etc/profile.d/autojump.sh ]] && source /etc/profile.d/autojump.sh
# [[ -s /usr/share/z/z.sh ]] && source /usr/share/z/z.sh
ZLUA="/usr/share/z.lua/z.lua"
[[ -s $ZLUA ]] && eval "$(lua $ZLUA --init bash enhanced once fzf)"

# chroot
CHROOT="$HOME/chroot"


# PATH=$PATH:/home/kuni/.local/bin/bin;export PATH; # ADDED BY INSTALLER - DO NOT EDIT OR DELETE THIS COMMENT - RealTime-At-Work RTaW-Sim 1.4.13 (Starter) DAAFF252-216B-107D-F1E5-3E22F3C424D6

# PATH=$PATH:/home/kuni/RTaW/RTaW-Sim-1.4.13-Starter/bin;export PATH; # ADDED BY INSTALLER - DO NOT EDIT OR DELETE THIS COMMENT - RealTime-At-Work RTaW-Sim 1.4.13 (Starter) 331454D4-2DA4-BCAE-7FA4-A780A5206F9B

# pnpm
export PNPM_HOME="/home/kuni/.local/share/pnpm"
export PATH="$PNPM_HOME:$PATH"
# pnpm end

# Nix
if [ -e '/nix/var/nix/profiles/default/etc/profile.d/nix-daemon.sh' ]; then
  . '/nix/var/nix/profiles/default/etc/profile.d/nix-daemon.sh'
fi
# End Nix
