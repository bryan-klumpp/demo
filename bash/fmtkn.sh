bdev=$(find /dev/disk/by-id|grep Kanguru | grep -v part)
echo $bdev
sd parted $bdev mktable gpt
sd parted $bdev mkpart primary ntfs 0% 100%
sd mkfs -t ntfs -f -L kt "$bdev"-part1
sync
