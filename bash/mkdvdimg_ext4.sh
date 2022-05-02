dd if=/dev/zero of=dvd.img bs=MiB count=4444 || return 10
sudo cryptsetup luksFormat dvd.img || return 20
sudo cryptsetup open dvd.img dvd_img || return 30
sudo mkfs.ext4 /dev/mapper/dvd_img || return 40
mkdir m && sudo chown b m
sudo mount /dev/mapper/dvd_img m || return 50
cd m && d


