[ $# -eq 0 ] && { c $(b 644)/sh; return; }


echo asdf
#it worked!!
eshalias=$(grep -E '\W'$1'=' /sh/b21_* )
isval $eshalias && { ealiases ; return; }

sfile=/sh/$1.sh
rchive 'before editing script '"$1.sh" "$sfile"
! test -f $sfile && newscript=yes || newscript=no
#nano --syntax=none $sfile   #--mouse disables selection so not always desirable
nano $sfile

test -f $sfile || return 84  #must not have saved new file, skip extra steps
#echo 'trying to copy' && cp -a $sfile /sh  
# co $newscript 'yes' && mkf  #does not seem to work unless you do manually

mkfa
