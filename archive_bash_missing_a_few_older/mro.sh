test $# -ge 3 && offset=$3 || offset=0
sudo mount -o ro,loop,offset=$offset "$1" "$2"
