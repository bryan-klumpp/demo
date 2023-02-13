imgf=/tmp/btrfs_DVD.img
imgd=/mnt/img
dd if=/dev/zero of="$imgf" bs=1 count=0 seek=4648730624 &&
sd cryptsetup luksFormat /tmp/btrfs_DVD.img &&
sd cryptsetup open /tmp/btrfs_DVD.img img &&
sd mkfs.ext4 /dev/mapper/img &&
sd mount /dev/*/img /tmp/img  #-o compress=zlib if btrfs &&
sd chown b /mnt/img && 
echo -n $imgd | clip && 
cd $(b 8) && { 
  echo 'please copy files to clipboard path: '$paste

return



  echo 'sample: find \| ug \'b322_.*(ogg|mp3|wav)|devices.*bigpatch\' |
    bxargs \'test -f {} && cp --no-clobber --parents {} '$imgd' || true'

sd umount /mnt/img
sd cryptsetup close img
growisofs -dvd-compat -Z /dev/sr0=/tmp/btrfs_DVD.img
