#https://kb.vmware.com/s/article/60262
/usr/bin/vmhgfs-fuse .host:/$1 /mnt/hgfs/$1 -o subtype=vmhgfs-fuse,allow_other
