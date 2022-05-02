test -e "$2" && { rm "$2" || return; }
test -e "$2" && return 44
ln -s "$1" "$2"

