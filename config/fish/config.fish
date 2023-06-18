# see also: https://github.com/jorgebucaran/cookbook.fish
#~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
#                                   Set values
#~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
# Hide welcome message
set fish_greeting
set VIRTUAL_ENV_DISABLE_PROMPT "1"
set -x MANPAGER "sh -c 'col -bx | bat -l man -p'"

# https://github.com/fish-shell/fish-shell/issues/1819#issuecomment-63728658
set -p fish_function_path (find ~/.config/77configs/config/fish/functions -mindepth 1 -type d)
# set -p __fish_config_dir (find ~/.config/77configs/config/fish/conf.d -mindepth 1 -type d)

## Export variable need for qt-theme
if type "qtile" >> /dev/null 2>&1
    set -x QT_QPA_PLATFORMTHEME "qt5ct"
end

# Set settings for https://github.com/franciscolourenco/done
set -U __done_min_cmd_duration 10000
set -U __done_notification_urgency_level low

set -gx EDITOR nvim
set -gx MANPAGER "sh -c 'col -bx | bat -l man -p'"

set -gx LYEDITOR "nvr +:'call cursor(%(line)s,%(char)s)' %(file)s"

#~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
#                               Environment setup
#~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
# Apply .profile: use this to put fish compatible .profile stuff in
if test -f ~/.fish_profile
    source ~/.fish_profile
end

# Add ~/.local/bin to PATH
if test -d ~/.local/bin
    fish_add_path ~/.local/bin
end

# Add ~/bin to PATH
if test -d ~/bin
    fish_add_path ~/bin
end

# Add depot_tools to PATH
if test -d ~/Applications/depot_tools
    fish_add_path ~/Applications/depot_tools
end


#~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
#                                   Functions
#~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
# Functions needed for !! and !$ https://github.com/oh-my-fish/plugin-bang-bang
function __history_previous_command
    switch (commandline -t)
        case "!"
            commandline -t $history[1]; commandline -f repaint
        case "*"
            commandline -i !
    end
end

function __history_previous_command_arguments
    switch (commandline -t)
        case "!"
            commandline -t ""
            commandline -f history-token-search-backward
        case "*"
            commandline -i '$'
    end
end

if [ "$fish_key_bindings" = fish_vi_key_bindings ];
    bind -Minsert ! __history_previous_command
    bind -Minsert '$' __history_previous_command_arguments
else
    bind ! __history_previous_command
    bind '$' __history_previous_command_arguments
end

# Fish command history
function history
    builtin history --show-time='%F %T '
end

function backup --argument filename
    cp $filename $filename.(date +%F-%T).bak
end

# Copy DIR1 DIR2
function copy
    set count (count $argv | tr -d \n)
    if test "$count" = 2; and test -d "$argv[1]"
        set from (echo $argv[1] | trim-right /)
        set to (echo $argv[2])
        command cp -r $from $to
    else
        command cp $argv
    end
end
