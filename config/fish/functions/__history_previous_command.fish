# Defined in /home/kevinb/.config/fish/config.fish @ line 57
function __history_previous_command \
    --description 'Function needed for !! and !$ https://github.com/oh-my-fish/plugin-bang-bang'
    switch (commandline -t)
        case "!"
            commandline -t $history[1]; commandline -f repaint
        case "*"
            commandline -i !
    end
end
