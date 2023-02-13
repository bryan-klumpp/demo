isval $1 && md "$*"
cheese -d /dev/video1
mvchnocl ~/Pictures/Webcam . 
mvchnocl ~/Videos/Webcam . 
mvchnocl ~/Webcam .





return
######old style make directory after the fact
dir="$(pwd)"
isval "$*" && { dir="$(underscore $(btime)_"$*")" && mkdir "$dir"; }
mvchnocl ~/Pictures/Webcam "$dir" &&
mvchnocl ~/Videos/Webcam "$dir" &&
mvchnocl ~/Webcam "$dir" &&
c "$dir"
