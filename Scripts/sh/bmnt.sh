test -e /mnt/$1 || return
isempty /mnt/$1 || return
test -e "$2" && sudo mount "$2" /mnt/$1 && echo 'mounted /mnt/'$1
