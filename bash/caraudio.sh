bmnt caraudio /dev/disk/by-label/caraud*
rm -R /mnt/caraudio/*
tros | bxargs 'sudo cp -a --parents {} /mnt/caraudio'
sudo umount /mnt/caraudio && echo 'you can remove caraudio media now'
