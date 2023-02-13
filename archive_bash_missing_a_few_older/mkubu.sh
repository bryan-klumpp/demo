bdev="$1"
isval $bdev || { bdev=$(find /dev/disk/by-id|grep Kanguru | grep -v part); test -e "$bdev" || return 92; }
cat /l/18045 | sddo "$bdev"
sd cat "$bdev" | ckubu18045
