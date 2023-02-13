












return

#older............

echo asdf
d34=/mnt/5tb/b_big_stuff/inbox/gopro
test -e /dev/disk/by-uuid/0C7D-6F26 || { c $d34; return; }
sudo mount /dev/disk/by-uuid/0C7D-6F26 /mnt/gopro
sudo /bin/mv /mnt/gopro/DCIM/*/* $d34
sudo umount /mnt/gopro
c $d34
allmine
