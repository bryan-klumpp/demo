[ $# -eq 0 ] && { c $(b 644)$(shpath); return; }

#shpath=$(first $(shpath) /c/b/code/demo/Scripts/sh /mnt/c/b/code/demo/Scripts/sh)
shpath=$(shpath)

echo 'using shpath: '$shpath

echo asdf
#it worked!!
eshalias=$(grep -E '\W'$1'=' "shpath"/b21_* )
isval $eshalias && { ealiases ; return; }

sfile="$shpath"/$1.sh
rchive 'before editing script '"$1.sh" "$sfile"
! test -f $sfile && newscript=yes || newscript=no
#nano --syntax=none $sfile   #--mouse disables selection so not always desirable
nano $sfile

test -f $sfile || return 84  #must not have saved new file, skip extra steps
#echo 'trying to copy' && cp -a $sfile "$shpath"  
# co $newscript 'yes' && mkf  #does not seem to work unless you do manually

mkfa
