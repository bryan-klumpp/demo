[ $# -eq 2 ] || return 1
test -e "$1" && ln -s "$1" "$2" || return 1