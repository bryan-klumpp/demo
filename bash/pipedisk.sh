mytmpfile=$(tmpfilename).pipe
#cat - > $mytmpfile & &>$mytmpfile
cat - > $mytmpfile
cat $mytmpfile
