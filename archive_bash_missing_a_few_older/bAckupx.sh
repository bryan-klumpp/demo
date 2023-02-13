isequal 2 $# || { echo 'wrong number of parameters to backup' "$@"; return 111; }
test -e "$1" || { echo 'file to backup does not exist?!' "$@"; return 111; }  
co "$1" 'Greed[2-9]|Moth[1-9]' && { return 0; } #silently skip this file for sensitivity reasons
test -f "$1" || { return 0; } #silently skip directories
