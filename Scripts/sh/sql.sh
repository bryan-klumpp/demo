isval "$2" && { echo 'quoting error - only one parameter allowed to sql function'; return 1; }
test -f "$1" && { sqlite3 /l/15 ".read $1"; err "$1"; return; }
my_sql="$1"
isval $my_sql && { sqlite3 /l/15 "$my_sql"; echo "sql \"$my_sql\" ###"; } || sqlite3 /l/15;
