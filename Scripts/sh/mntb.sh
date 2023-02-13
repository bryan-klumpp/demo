

[ $# -eq 0 ] && { echo 'usage: mntb 4t3 /dev/disk/by-uuid/asefef3as33 /4t3 [,compress=zli...,autodefrag]'; return; }
#btrfs mount
mn=$1; dv=$2; mp=$3; opts=$4  #nosuid,nodev,nofail,x-gvfs-show,noauto,sync,noatime,  [btrfs]compress=zli...,autodefrag
test -e $mp || return 43
isempty $mp || return 23
test -e $dv || return 22
encdev=/dev/mapper/enc_$mn
test -e $encdev || sd cryptsetup open --keyFile /ram/luks $dv enc_$mn || return 33
sd mount -o nosuid,nodev,nofail,x-gvfs-show,noauto,sync,noatime$opts $encdev $mp   #,sync,noatime are additions to Ubuntu defaults






return ########################################################################################

[ $# -eq 0 ] && { echo 'usage: mnt 5tb fji3j3ijfs8sl'; return; }
isempty /mnt/$1 || return 39;    ###if there are files, must be already mounted but this is expensive with Toshiba drives
mount|grep -E '^/mnt/'$1' ' > /dev/null && return 33
test -e $2 || return 40 
#clearname="$(echo -n "$1" | sed --regexp-extended 's#[^A-Za-z0-9]#_#g')c"
clearname=$1'c'
! test -e /dev/mapper/$clearname && { sudo cryptsetup open $2 "$clearname" || return 44; }     #NOTE: can also pipe password to cryptsetup
sudo mount "/dev/mapper/$clearname" /mnt/$1 &&
echo 'mounted '$1


#cryptsetup open --key-file=
