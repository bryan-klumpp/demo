dev=$1
mount | grep $dev && { echo 'mounted!!'; return 33; }

sd parted $dev mktable gpt
