#/mnt/5tb_4/iso/debian/1 ordered_at_Hardees_from_linuxcollections_com/debian-8.1.0-i386-DVD_verified/debian-8.1.0-i386-DVD-$1.iso
#/b/big/iso/debian-8.6.0-i386-DVD/debian-8.6.0-i386-DVD-$1.jigdo
cd /b/big/iso/debian-8.6.0-i386-DVD &&
sudo mount -o ro "/b/big/iso_copy/debian-8.1.0-i386-DVD_verified/debian-8.1.0-i386-DVD-$1.iso" /mnt/iso &&
jigdo-lite --noask --scan /mnt/iso /b/big/iso/debian-8.6.0-i386-DVD/debian-8.6.0-i386-DVD-$1.jigdo &&
sudo umount /mnt/iso &&
echo 'bjig for #'$1' successful !!'
