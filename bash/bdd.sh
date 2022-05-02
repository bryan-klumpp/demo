echo 'see script source for examples'; return;

gsettings set org.gnome.desktop.media-handling automount false && crc32 <(sudo dd if=/dev/sdbare  | pv | tee safefile.img) | tee copying__to__crc32.txt

################### find id first and CROSSCHECK with /dev/sdX letter
ls -l /dev/disk/by-id; return;
gsettings set org.gnome.desktop.media-handling automount false && crc32 <(     dd if=safefile.img | pv | tee /dev/disk-by-id/usb-...........) | tee copying__to__crc32.txt