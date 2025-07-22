syncd=${HOME}/l/8/setup/sync
brs /etc/fstab $syncd/etc commit
brs /etc/crypttab $syncd/etc commit
brs /etc/sudoers $syncd/etc commit
sd cp -a /root/keyfile $syncd/root 
