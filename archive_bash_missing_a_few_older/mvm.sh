#test -e /dev/disk/by-partlabel/id_master_laptop_part || { echo 'you are not on the master laptop'; return 111; }
/bin/mv --verbose --no-clobber "$@"
co "$*" '\Wb[0-9]*_' && { bln "$1"; bln "$2"; }
#
