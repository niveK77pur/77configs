# Defined via `source`
function mirrora \
    --wraps='sudo reflector --latest 50 --number 20 --sort age --save /etc/pacman.d/mirrorlist' \
    --description 'Get fastest mirrors (sort by age)'
  sudo reflector --latest 50 --number 20 --sort age --save /etc/pacman.d/mirrorlist $argv
        
end
