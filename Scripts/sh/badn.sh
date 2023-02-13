logfile=/b/disk/$(/b/sh/btime.sh)" badblocks -nv -t 0x00 -c 1024 _dev_disk_by-label_$1 badblocks.txt"
                                   badblocks -nv -t 0x00 -c 1024 /dev/disk/by-label/$1 > "$logfile" 2>&1
#-s show status, -w (instead of -n) destructive write