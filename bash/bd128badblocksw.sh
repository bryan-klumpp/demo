bbdisk=$1
test -e $bbdisk || return 5

cd /media/b/5tb/SPECIAL_nocopy_bd128 || return 10
! test -e bd128.img || return 15
sudo dd if="$bbdisk" | pv |
  tee >(md5sum - | > bd128.md5) > bd128.img || return 40
echo 'backup complete; starting destructive badblocks' && 

return

sudo badblocks -wsv -t 0xff $bbdisk  || return 60 
sudo dd if=/dev/bd128.img | pv > "$bbdisk" || return 70
#here we can rename img file with md5sum
echo 'successfully tested and restored bd128 microSD card !'

