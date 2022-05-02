[ $# -lt 2 ] && { echo 'Usage: mkluks /dev/sdx coollabel' ; return; }
#luks #no need for clipboard now
sudo cryptsetup luksFormat $1 --key-file /ram/google2               || return 101  #maybe should prompt, specifying keyfile is BUGGY
sudo cryptsetup open --key-file /ram/google2 $1 "$2"clear || return 119
sudo mke2fs -t ext4 -L $2 /dev/mapper/"$2"clear             || return 11
sudo cryptsetup close "$2"clear || return 39
blk; return ###need to manually specify uuid in mall.sh
test -e /mnt/$2 || sudo mkdir /mnt/$2 && sudo chown b /mnt/$2 || return 92
cat /ram/google2 | bmnt /dev/mapper/"$2"clear $2 || return 34
c /mnt/$2
