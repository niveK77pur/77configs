# Defined via `source`
function rip --wraps=expac\ --timefmt=\'\%Y-\%m-\%d\ \%T\'\ \'\%l\\t\%n\ \%v\'\ \|\ sort\ \|\ tail\ -200\ \|\ nl --description 'Recent installed packages'
  expac --timefmt='%Y-%m-%d %T' '%l\t%n %v' | sort | tail -200 | nl $argv
        
end
