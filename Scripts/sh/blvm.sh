#for pwd see billfold or unsafe; full path for 1tb /dev/disk/by-uuid/c6dcbbd7-d21c-43f7-8c01-25d3c1ca81c8
#  cd /dev/disk/by-uuid ############
#test -z $1 && { echo 'need to specify uuid as parameter.  Choices:'; ls -l; return; }
luks
test -d /mnt || sudo mkdir /mnt &&
test -d /mnt/bext || sudo mkdir /mnt/bext &&
test -d /mnt/bextboot || sudo mkdir /mnt/bextboot &&
sudo mount -o ro /dev/disk/by-uuid/3978fac6-7e44-4050-9498-97e1b94891c6 /mnt/bextboot &&
#sudo apt-get install lvm2 || dpkg -i /mnt/bextboot/lvm2_2.02.111-2.2+deb8u1_i386.deb &&
test -e /dev/mapper/bec || sudo cryptsetup open /dev/disk/by-uuid/c6dcbbd7-d21c-43f7-8c01-25d3c1ca81c8 bec &&   
sudo lvchange -ay /dev/hp15-vg/root &&
sudo mount /dev/mapper/hp15--vg-root /mnt/bext &&
ls /mnt/bext/b/sh/setup*sh
#set -x
#alias sudo=command
# . setup1.sh
