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
