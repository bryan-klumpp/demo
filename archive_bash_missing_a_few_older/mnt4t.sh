mkdir ~/4t
/usr/bin/sudo cryptsetup open /dev/disk/by-uuid/78146748-15c1-4567-bfa7-e889eb2cce30 4tclear || exit 3 
/usr/bin/sudo mount /dev/mapper/4tclear ~/4t || exit 8
/usr/bin/sudo -K || exit 9
c ~/4t
