mount | grep $1 && { echo 'mounted!'; return 35; }
sd parted -s $1 mktable msdos &&
sd parted $1 mkpart primary fat32 0% 90% &&
sd mkfs -t fat "$1"1
