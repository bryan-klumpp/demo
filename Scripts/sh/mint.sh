sn=$1

test -e /dev/mapper/$sn || sd cryptdisks_start $sn

sd mount -a