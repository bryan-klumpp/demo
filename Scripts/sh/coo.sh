#no worky [ $# -eq 2 ] && { [[ "$1" =~ "$2" ]]; return; }
#no worky[ $# -eq 3 ] && [[ "$1" =~ "$2" ]] && command { shift 2 && "$@"; return; }
[ $# -eq 2 ] && { echo -n "$1" | grep -E "$2" > /dev/null; return; }
err 'wrong # of parameters to Co.sh'; return 111;