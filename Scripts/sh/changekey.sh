bdev=/dev/disk/by-uuid/c6dcbbd7-d21c-43f7-8c01-25d3c1ca81c8
isval $1 && bdev=$1 
sudo cryptsetup luksChangeKey $bdev --key-file /b/google/x1