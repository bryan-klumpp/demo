test -e /mnt/4t/b && test -e /mnt/bigloc/4t || return 5  #ensure mounted
cd /mnt/4t || return 10
f | safe | size512 | bcp /mnt/bigloc/4t || return 20

return ########_old implementation below
###brsync alternative --delete-missing implementation
test -L /b && { echo '/b cannot be symbolic link, dangerous' ; return 111; }

excludebig='/(l|big)/|\.(wav|mp4|mpg|exe|zip)$|archive|backup|copy'

cd /media/b/5tb/SPECIAL_formerly_bd128_transferring_to_5tb_on_20171124 || return 111;
f | grep -iEv "$excludebig" | size

sleep 5
cd /b && f | bxargs '! test -e /media/b/bd128/{} && rm {} || true' && cd /media/b/bd128 &&
{ f | grep -iEv "$excludebig"; find tmpmob; } | 
 bxargs 'test -f {} && test {} -nt /b/{} && 
  cp -d --preserve=all --verbose --parents {} /b || true'









#brs $(pwd) /bmob /l/ /big/ wav mp4 archive backup copy Moth1 Moth2 Moth3 Moth4 Moth5 Moth6 Moth7 Moth8 Moth9 "$@"
