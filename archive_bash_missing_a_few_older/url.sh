test -f "$1" && { a firefox "$(cat "$1")"; return; }
a firefox "$@"
