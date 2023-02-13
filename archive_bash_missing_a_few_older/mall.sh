for mp in $(cat /l/8/setup/mountpoints.txt); do { 
  echo attempting $mp
  mint $mp;
} done; return; #######################

mint 4w2
mint 4w3
mint 4w4
mint 4s2
mint 4s3
mint 4s4



return ############################################

mntb e   /dev/disk/by-uuid/b0c42d42-7e22-4063-afc3-b24f12b3ab6e /e   ,ssd
mntb ee  /dev/disk/by-uuid/797d342a-ef43-4433-8de6-477421a6940d /ee  ,ssd

#Western Digital fast 4tb
mntb 4w1 /dev/disk/by-uuid/b7e409a8-531f-4f0d-bf41-23b0b13cafaf /4w1 ,autodefrag
mntb 4w2 /dev/disk/by-uuid/bf170616-68c6-4d4a-a07a-5225be193f19 /4w2 ,autodefrag
mntb 4w3 /dev/disk/by-uuid/a6b0c44f-f10a-450d-9216-b6f05d3b4991 /4w3 ,autodefrag

#Seagate slow 4tb
mntb 4s2 /dev/disk/by-uuid/2618b1d0-e9cf-41d4-b160-78a320193732 /4s2 ,autodefrag
mntb 4s3 /dev/disk/by-uuid/103b843b-4b73-4fdb-a21e-30c7b27566f0 /4s3 ,autodefrag
mntb 4s4 /dev/disk/by-uuid/a910e744-04d3-4789-9f59-6714d2a2193e /4s4 ,autodefrag



return ###########################################################################################

test -e /home/b/b/b444_* && cat /home/b/b/b444_* | trim > /ram/google2
test -e /ram/google2 || { echo -n 'enter password for /ram/google2 and press Enter and Ctrl+D: ';
    dd | trim | dd of=/ram/google2 ; }

#cat /ram/google2 | mntenc sdold /dev/disk/by-id/mmc-SL200_0x2109c938-part1
cat /ram/google2 | mntenc sd /dev/disk/by-uuid/6d56efa9-9772-4f1e-9cd2-6e6824479f9c #new on thumb drive
cat /ram/google2 | mntenc 200g /dev/disk/by-uuid/5aa2b717-1656-4e75-97a7-2310c1e4c648
cat /ram/google2 | mntenc 3tb /dev/disk/by-uuid/a09e3413-dbd9-4bba-b3cb-657cfb4bf65a
cat /ram/google2 | mntenc 4t /dev/disk/by-uuid/78146748-15c1-4567-bfa7-e889eb2cce30 #new 4TB portable hd
cat /ram/google2 | mntenc 5tb /dev/disk/by-uuid/e8112194-6a2f-4790-8ffd-214b017fa6ef


return ########undocumented junk below
test -e /ram/google2 || { 
  test -e /mnt/CARAUDIO/google || { bmnt CARAUDIO /dev/disk/by-label/CARAUDIO; } || return 32
  cat /mnt/CARAUDIO/google|grep -oE '^.{16}' > /ram/google2 ; sudo umount /mnt/CARAUDIO
}
#--key-file
#bmnt bb /dev/disk/by-uuid/369523a9-24e6-49b3-a6cd-0cee708fa3e8
#bmnt blocal /dev/disk/by-label/blocal
test -e /b/l/4/x1 && cp /b/l/4/x1 /ram/google
bmnt beckysd /dev/disk/by-label/Becky
#cat /ram/google | mntenc 64gsd /dev/disk/by-uuid/9fec46e4-26a9-484e-b744-5dcc8860ae56
cat /ram/google2 | mntenc bigloc /dev/disk/by-uuid/047ab18f-a94c-4378-b298-049be431e173
cat /ram/google2 | mntenc sd /dev/disk/mmcblk0p1
#cat /ram/google | mntenc bigloc /dev/disk/by-uuid/e8211107-8342-451f-9da3-387da8e28c1a
#cat /ram/google | mntenc bd128 /dev/disk/by-uuid/bf8c3106-d722-4848-9911-dd611e0dfebb
#cat /ram/google | mntenc locenc /dev/disk/by-uuid/b00f6d60-ae33-4b17-962f-5ac5ae85ac7f #hp15t


return #lets just stick with 5tb for now and forget the below
#################
#for safety, do with original disconnected - got duplicate error at some point
mnt=aaaaaaaaaaaaaaaaaaaaaaaaa
mkdir "$mnt"
sudo losetup -f --show -o 256901120 /med/5tb_1/img/*img
loopdev=aaaaaaaaaaaaaaaaaaaaaaa
sudo cryptsetup open /dev/loop0 archiveloop0
sudo lvm    #vgchange -a
mount -o ro /dev/mapper/... "$mnt"

#umount "$mnt"
#lvm deactivate
#cryptsetup close archiveloop0
#losetup -d "$loopdev"
