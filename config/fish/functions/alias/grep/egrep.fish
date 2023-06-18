# Defined via `source`
function egrep --wraps='grep -E --color=auto' --description 'alias egrep=grep -E --color=auto'
  grep -E --color=auto $argv
        
end
