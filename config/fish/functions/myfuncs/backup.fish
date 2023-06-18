# Defined in /home/kevinb/.config/fish/config.fish @ line 81
function backup --argument filename
    cp $filename $filename.(date +%F-%T).bak
end
