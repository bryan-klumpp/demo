[ $# -eq 0 ] && { c $(b 644)/sh; return; }



#it worked!!
eshalias=$(grep -E '\W'$1'=' /sh/b21_* )
isval $eshalias && { echo "$eshalias" ; return; }

sfile=/sh/$1.sh
rchive 'before editing script '"$1.sh" "$sfile"
! test -f $sfile && newscript=yes || newscript=no
#nano --syntax=none $sfile   #--mouse disables selection so not always desirable
a kate $sfile
test -f $sfile || return 84  #must not have saved new file, skip extra steps
#echo 'trying to copy' && cp -a $sfile /sh  
# co $newscript 'yes' && mkf  #does not seem to work unless you do manually
