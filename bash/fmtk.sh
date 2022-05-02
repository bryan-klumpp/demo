bdev=$(find /dev/disk/by-id|grep Kanguru | grep -v part)
echo $bdev
sd parted $bdev print
