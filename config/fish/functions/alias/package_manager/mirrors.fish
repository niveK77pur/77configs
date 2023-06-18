# Defined via `source`
function mirrors \
    --wraps='sudo reflector --latest 50 --number 20 --sort score --save /etc/pacman.d/mirrorlist' \
    --description 'Get fastest mirrors (sort by score)'
  sudo reflector --latest 50 --number 20 --sort score --save /etc/pacman.d/mirrorlist $argv
        
end
