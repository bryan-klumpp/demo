[ $# -eq 0 ] && { err 'expected at least one value'; return 111; }
echo "$1"