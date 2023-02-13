isval "$2" && { echo 'quoting error - only one parameter allowed to sql function'; return 1; }
test -f "$1" && { sqlite3 /l/15 ".read $1"; return; }
sqlite3 /l/15 "$1" | head -n 1 | trim
