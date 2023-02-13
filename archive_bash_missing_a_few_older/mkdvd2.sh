cd ..
sd umount $imgd &&
sd cryptsetup close /dev/mapper/img &&
growisofs -dvd-compat -Z /dev/sr0=$imgf &&
crc32 $imgf | tee /b/crc32 &&
echo label: crc32: $(cat /b/crc32) size: $(ls /b/dvd.img | size)


return

  echo 'sample: find \| ug \'b322_.*(ogg|mp3|wav)|devices.*bigpatch\' |
    bxargs \'test -f {} && cp --no-clobber --parents {} '$imgd' || true'

