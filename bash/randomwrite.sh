co $1 '^/dev/' || { echo 'make sure its really a device'; return 81; }
mount|grep $1 && { echo 'make sure its not mounted'; return 82; }
dd if=/dev/urandom | pv | dd of=$1
