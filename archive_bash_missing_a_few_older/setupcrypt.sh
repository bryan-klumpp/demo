############ much thanks/credit to https://www.howtoforge.com/automatically-unlock-luks-encrypted-drives-with-a-keyfile


sd dd if=/dev/urandom of=/root/keyfile bs=1024 count=4  #create PC keyfile if needed
sd echo -n fiejs'$$$jfisje*uUifesvjeslaA' | sd tee -a /root/keyfile   #tweak, add some extra manual pwd

#only run this section once per disk
cryptsetup luksAddKey /dev/disk-by-uuid/ /root/keyfile