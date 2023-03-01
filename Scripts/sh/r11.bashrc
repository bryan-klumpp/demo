shopt -s globstar
echo g | sudo cryptsetup open /dev/disk/by-uuid/9fe*e56 64gsdclear
sudo mount /dev/mapper/64gsdclear /b
test -e /b/l/13 || { cd /b; . **/b1_*/bln.sh; }
. /b/l/13
