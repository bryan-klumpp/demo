#yes it works
#[ $# = 0 ] && { a /usr/bin/vlc *mp3; return; }
test -z "$1" && { a vlc *; return; }
a /usr/bin/vlc "$@" #rhythmbox

