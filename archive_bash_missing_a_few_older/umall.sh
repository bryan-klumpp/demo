cd
for mp in $(cat /l/8/setup/mountpoints.txt); do { 
  sd umount /$mp && sd cryptdisks_stop $mp  
} done;

return; #######################



isempty /4 || { sd umount /4 && sd cryptsetup close 4tclear && echo 'ok to remove 4t'; }
sd umount /media/b/*
sd umount /mnt/*