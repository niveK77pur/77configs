# Defined via `source`
function mirrord \
    --wraps='sudo reflector --latest 50 --number 20 --sort delay --save /etc/pacman.d/mirrorlist' \
    --description 'Get fastest mirrors (sort by delay)'
  sudo reflector --latest 50 --number 20 --sort delay --save /etc/pacman.d/mirrorlist $argv
        
end
