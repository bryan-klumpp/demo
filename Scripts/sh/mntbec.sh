#sudo mount -t cifs -o username=Becky //192.168.0.50/share /mnt/bec
sudo mount -t cifs -o rw,password=$(cat $(b 4)/becky),username=Becky,domain=BECKY-PC,addr=192.168.$1 //192.168.$1/Users/Becky /mnt/bec \
  && c /mnt/bec/Documents



#sudo mount -t cifs -o rw,relatime,vers=1.0,cache=strict,password=ABCDEFG,username=Becky,domain=BECKY-PC,uid=0,noforceuid,gid=0,noforcegid,addr=192.168.$1,file_mode=0755,dir_mode=0755,nounix,serverino,rsize=61440,wsize=65536,actimeo=1 //192.168.$1/Users/Becky /mnt/bec \

