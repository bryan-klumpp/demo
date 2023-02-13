co "$1" '^('"$2"')$'

return #################3
#buggy[ $# -eq 2 ] && { [[ "$1" =~ ^"$2"$ ]]; return; }
[ $# -eq 2 ] && { echo -n "$1" | grep -iE '^'"$2"'$' > /dev/null; return; }
#no worky[ $# -eq 3 ] && [[ "$1" =~ "$2" ]] && command { shift 2 && "$@"; return; }
err 'wrong # of parameters to is.sh'; return 111;
