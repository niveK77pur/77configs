# Defined in /home/kevinb/.config/fish/config.fish @ line 66
function __history_previous_command_arguments \
    --description 'Function needed for !! and !$ https://github.com/oh-my-fish/plugin-bang-bang'
    switch (commandline -t)
        case "!"
            commandline -t ""
            commandline -f history-token-search-backward
        case "*"
            commandline -i '$'
    end
end
