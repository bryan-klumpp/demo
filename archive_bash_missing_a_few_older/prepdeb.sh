function ee() {
  sudo mount -o ro /b/big/iso/debian-8.6.0-i386-DVD/debian-8.6.0-i386-DVD-$1.iso /mnt/iso &&
  sudo mkdir /mnt/hp5/setup/iso_extracted/$1
  sudo cp -a /mnt/iso /mnt/hp5/setup/iso_extracted/$1
  #cp -a /mnt/iso/* /b/big/deb/debian-8.6.0-i386-DVD-$1 &&
  #apt-cdrom --no-auto-detect -d /b/big/deb/debian-8.6.0-i386-DVD-$1 -m add
  sudo umount /mnt/iso || { echo 'error unmounting /mnt/iso'; return 111; }
} &&
ee 1 && ee 2 && ee 3 && ee 4 && ee 5 && ee 6 && ee 7 && ee 8 && ee 9 && ee 10 && ee 11 && ee 12 && ee 13 
