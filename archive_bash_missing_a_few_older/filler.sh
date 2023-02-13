filler=$1
while true; do {
  ####echo -n $(pwd) | grep $filler || return 33
  test -f z.$filler && mv z.$filler $RANDOM$RANDOM.$filler
  dd if=/dev/$filler bs=MiB count=4096 | pv | dd of=z.$filler iflag=fullblock oflag=direct bs=MiB || return 83
} done

#pv -L 50M