wcgdev=/dev/video0
test -e /dev/video1 && wcgdev=/dev/video1
vgrabbj -d $wcgdev 2>/tmp/wcg_error.log > "$@"
#-i vga
