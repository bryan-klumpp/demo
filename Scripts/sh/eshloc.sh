eshalias=$(grep -E '\W'$1'=' $(shpath)/b21_* )
isval $eshalias && { echo "$eshalias" ; return; }

sfile=$(shpath)/$1.sh
! test -f $sfile && newscript=yes || newscript=no
nano --syntax=none $sfile   #--mouse disables selection so not always desirable
co $newscript 'yes' && test -f $sfile && mkf
test -e $(b 644) && echo 'trying to copy' && cp -a $sfile $(b 644)  #update local copy at least, if new (above) then copy to master and regen all scripts
