# Defined via `source`
function l. --wraps='exa -ald --color=always --group-directories-first --icons .*' --description 'alias l.=exa -ald --color=always --group-directories-first --icons .*'
  exa -ald --color=always --group-directories-first --icons .* $argv
        
end
