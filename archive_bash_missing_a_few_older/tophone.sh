[ $# -eq 0 ] && tophone *mp3  #infinite loop if no mp3 files
mount | grep phonesd || { sudo mount /dev/disk/by-label/phonesd /mnt/phonesd; }
sudo rm -R /mnt/phonesd/audio/*
sudo cp "$@" /mnt/phonesd/audio
sudo umount /mnt/phonesd && sleep 5 && echo 'you can put SD card in phone now'
