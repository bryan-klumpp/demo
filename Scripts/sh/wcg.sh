wcgdev=/dev/video0
test -e /dev/video1 && wcgdev=/dev/video1
#vgrabbj -i qcif -d $wcgdev > $(b 80)/$(btime)_webcamgrab_wcg_lifelog.jpg
vgrabbj -i vga -d $wcgdev 2>/tmp/wcg_error.log > $(b 80)/$(btime)_webcamgrab_wcg_lifelog_$1.jpg  #nolog annoying console on batch process from 2>


# dangerous to change parameters vgrabbj -W '0' -r '0' -x '30000' -b 65535 -u '0' -i svga > $(b 80)/$(btime)_webcamgrab_wcg_lifelog.jpg
#w=whiteness, r=color, x=contrast, b=brightness, u=hue (credit info page) 
