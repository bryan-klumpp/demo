while true; do test -e $1 && dd if=/dev/urandom bs=1M | pv | sudo dd bs=1M seek=0 of=$1 ; done
