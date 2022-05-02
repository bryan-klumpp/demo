isval $1 || { lsblk; return; }
sudo cryptsetup luksChangeKey /dev/$1	 
#sudo cryptsetup luksDump $1	
