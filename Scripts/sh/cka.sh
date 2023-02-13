{

#bbtrfsck /e /dev/mapper/luks-b0c42d42-7e22-4063-afc3-b24f12b3ab6e
#bbtrfsck /ee /dev/mapper/luks-797d342a-ef43-4433-8de6-477421a6940d

#bbtrfsck 4w2 /dev/mapper/luks-b7e409a8-531f-4f0d-bf41-23b0b13cafaf
#bbtrfsck 4w3 /dev/mapper/luks-bf170616-68c6-4d4a-a07a-5225be193f19
bbtrfsck 4w4 /dev/mapper/luks-a6b0c44f-f10a-450d-9216-b6f05d3b4991

} | tee /tmp/$(btime)_cka.log

echo 'see log: '/tmp/$(btime)_cka.log
