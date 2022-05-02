not isempty /mnt/$1 && sudo umount /mnt/$1
test -e /dev/mapper/"$1"clear && sudo cryptsetup close /dev/mapper/"$1"clear 
