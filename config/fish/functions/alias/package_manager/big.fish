# Defined via `source`
function big \
    --wraps=expac\ -H\ M\ \'\%m\\t\%n\'\ \|\ sort\ -h\ \|\ nl \
    --description 'Sort installed packages according o size in MB'
  expac -H M '%m\t%n' | sort -h | nl $argv
        
end
