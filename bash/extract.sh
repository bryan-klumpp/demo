mkdir extracted
for((i=1;$i<15;i++));do
test -d *-DVD-$i.iso && {
  mkdir extracted/$i
  sudo mount -o ro *-DVD-$i.iso /mnt/iso
  sudo cp -a /mnt/iso/* extracted/$i
  sudo umount /mnt/iso
}
done
allmine
# mntt=/b/mntt
# sudo mount -o ro *$1.iso $mntt
# target=src/$1
# mkdir $target
# cp -a $mntt/* $target
# sudo umount $mntt


