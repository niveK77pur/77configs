# Defined via `source`
function mirror --wraps='sudo reflector -f 30 -l 30 --number 10 --verbose --save /etc/pacman.d/mirrorlist' --description 'Get fastest mirrors'
  sudo reflector -f 30 -l 30 --number 10 --verbose --save /etc/pacman.d/mirrorlist $argv
        
end
