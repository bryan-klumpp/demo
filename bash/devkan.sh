bdev=$(find /dev/disk/by-id|grep Kanguru | grep -v part)
test -e "$bdev"-part1 || err 'caution - Kanguru -part1 missing'
echo -n $bdev
