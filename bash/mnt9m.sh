sudo cryptsetup open $(b 999) S9c
sudo mount -o ro /dev/mapper/S9c ~/9
#{ sleep 1800; { sudo umount -f -l -v ~/9; sudo cryptsetup close S9c; } 2>&1 >> /tmp/umount9.log; } & disown

