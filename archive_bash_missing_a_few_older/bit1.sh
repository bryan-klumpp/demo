
sd dislocker -r /dev/disk/by-uuid/asdf -- /bdev/bitlocker && #-u<pasword>
sd mount -r -t ntfs-3g -o loop /bdev/bitlocker/dislocker-file /z

