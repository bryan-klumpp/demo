
test -e ${HOME}/l || { sudo mkdir ${HOME}/l && sudo chown b ${HOME}/l; }
echo '' > /tmp/dummyrc

bln1 /c/b
bln1 /mnt/c/b
bln1 /b
bln1 ~

