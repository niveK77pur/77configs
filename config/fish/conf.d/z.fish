set -l ZLUA /usr/share/z.lua/z.lua

if [ -f $ZLUA ]
    lua $ZLUA --init fish | source
end
