# Defined via `source`
function cleanup \
    --wraps='sudo pacman -Rns (pacman -Qtdq)' \
    --description 'Cleanup orphaned packages'
  sudo pacman -Rns (pacman -Qtdq) $argv
        
end
