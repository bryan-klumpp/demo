echo 'see editgrub2 as well for more funct not tested'
sudo sed --in-place --regexp-extended 's/--fs-uuid (.*)0884a345-972e-46b2-88de-85906ab2b51b/\1--label sdamd64/' grub.cfg #tweak disk label as needed
sudo sed --in-place --regexp-extended 's/set root=.hd.,msdos../#\0/' grub.cfg  #simply comment out initial setroot; note period substituted for quote for convenience
