imgf=/b/dvd.img
imgd=/tmp/img
#sz=$(( 4648730624 + ( 32768 * 4092 ) )) # * 1564 gets you right under 4700... - but for some DVDs need less :-(
sz=4521984000  # just forget about pushing boundaries, maybe can burn this with Brasero
#sz=$(( 8388608000 + ( 32768 * 4092 ) ))  #was able to burn 4092, size 8,522,694,656
test -e $imgd || mkdir $imgd
isempty $imgd || sd umount $imgd || return 72
test -e /dev/*/img && { sd cryptsetup close /dev/*/img || return 92; }

initimgf=''
test -e $imgf || { initimgf='true'
                   dd if=/dev/zero of=$imgf bs=1 count=0 seek=$sz 
                   sd cryptsetup luksFormat /b/dvd.img &&
                   sd cryptsetup open /b/dvd.img img &&
                   sd mkfs.btrfs -M /dev/mapper/img || return 82; }  #-M saves space with mixed mode at expense of performance https://btrfs.wiki.kernel.org/index.php/Manpage/mkfs.btrfs - not sure  -n 65536 might not waste space; try btrfs fi du /dev/img

if not [ $initimgf ]; then sd cryptsetup open /b/dvd.img img; fi
sd mount -o compress=zlib,noatime /dev/mapper/img $imgd   &&
sd chown b $imgd && 
echo -n $imgd | clip
mount |g $imgd  # ???
cd $(b 8) && echo 'please copy files to clipboard path: '$(paste)

return



  echo 'sample: find \| ug \'b322_.*(ogg|mp3|wav)|devices.*bigpatch\' |
    bxargs \'test -f {} && cp --no-clobber --parents {} '$imgd' || true'

sd umount /mnt/img
sd cryptsetup close img
growisofs -dvd-compat -Z /dev/sr0=/b/btrfs_DVD.img
