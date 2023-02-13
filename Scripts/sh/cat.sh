[ $# -eq 0 ] && test -f "$(paste)" && { /bin/cat "$(paste)"; return; }
/bin/cat "$@"
