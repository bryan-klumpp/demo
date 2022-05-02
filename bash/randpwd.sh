dd if=/dev/random bs=1 count=500 | tr -dc 'a-zA-Z0-9#$*&!' | fold -w 63 >> $(b 4)/random
