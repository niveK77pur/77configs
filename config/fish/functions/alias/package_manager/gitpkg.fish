# Defined via `source`
function gitpkg \
    --wraps=pacman\ -Q\ \|\ grep\ -i\ \"\\-git\"\ \|\ wc\ -l \
    --description 'List amount of -git packages'
  pacman -Q | grep -i "\-git" | wc -l $argv
        
end
