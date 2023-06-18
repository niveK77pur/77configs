# Defined via `source`
function fgrep --wraps='grep -F --color=auto' --description 'alias fgrep=grep -F --color=auto'
  grep -F --color=auto $argv
        
end
