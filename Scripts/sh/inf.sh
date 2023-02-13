cat=$1; shift 1
[ $# -ge 1 ] && { info $cat | g "$@"; return; }
info $cat|less -R
