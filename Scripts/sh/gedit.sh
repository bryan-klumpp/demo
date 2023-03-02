test -e /usr/bin/kate && { a kate "$@"; return; }
/usr/bin/gedit "$@"
