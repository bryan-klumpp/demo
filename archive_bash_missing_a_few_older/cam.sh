test -e "$(echo /mnt/DSC-W830/*|head -n 1)" || sudo mount /dev/disk/by-label/DSC-W830 /mnt/DSC-W830
mv /mnt/DSC-W830/DCIM/*/* $(b 30)
mv /mnt/DSC-W830/MP_ROOT/*/* $(b 30)
c $(b 30)
sudo umount /mnt/DSC-W830
