isint $1 5 && { C='-B '$1; shift 1; } || { C=''; }
isval $1 || { echo 'error, no pattern passed to G()'; return 2; }
#parameter order matters (if using $@), expression must be next arg due to -e and then optional parameters can follow
mygs='--group-separator='$gs; isval "$C" ||  mygs=''
isval $3 && { grep -iE --color=always  -e "$1" |
              grep -iE --color=always  -e "$2" |
              grep -iE --color=auto $mygs $C -e "$3"; return; }
isval $2 && { grep -iE --color=always  -e "$1" |
              grep -iE --color=auto $mygs $C -e "$2"; return; }
isval $1 &&   grep -iE --color=auto $mygs $C -e "$1"
