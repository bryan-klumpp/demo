[ $# -eq 0 ] && { catfile='-'; } || catfile=$(f1 "$*")
cat "$catfile"