isint $1 5 && { C=$1; shift 1; } || { C=0; }
isval $1 || { echo 'error, no pattern passed to G()'; return 2; }
#tricky, expression must be next arg due to -e and then optional parameters can follow
mygs=$gs
[ $C -eq 0 ] && mygs=
isval $3 && { grep -E --color=always  -e "$1" |
              grep -E --color=always  -e "$2" |
              grep -E --color=auto --group-separator=$mygs -e "$3"; return; }
isval $2 && { grep -E --color=always  -e "$1" |
              grep -E --color=auto --group-separator=$mygs -e "$2"; return; }
isval $1 && grep -E --color=auto --group-separator=$mygs -B $C -e "$1"
