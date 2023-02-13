mnt=/$1   #########; dev=$2
echo checking "$mnt"......
isempty $mnt || sd umount --force $mnt || return 10
isempty $mnt &&
sd btrfsck /dev/mapper$mnt &&
sd mount $mnt ; return ########return########## &&
sd btrfs scrub start -c 2 -n 3 $mnt || return 30
#retcd=$?

#tail -f /var/lib/btrfs/scrub.status.cc0e87aa-8164-4595-a25f-8abfc248d023
statf=/tmp/bbtrfsckstat$RANDOM
echo '' > $statf
while ! grep 'finished after' $statf; do { sleep 5 || break; sd btrfs scrub status $mnt | tee $statf | cat - 1>&2; } done

