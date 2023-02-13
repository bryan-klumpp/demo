[ $# -eq 0 ] && { c 100; return; }
#firstp="$1"; shift 1

find "$(b 100)" -mindepth 1 | ug 'inuse|propac|disposed|receipt|lostlost' | 
  mg "$@" | sort
#  grep --color=always -E "^."  #extra grep to highlight including first char of line to mark long lines


#  grep -iE --color=always "$*"$leaf | grep -iE --color=always "$*"  #second grep to highlight without $leaf

