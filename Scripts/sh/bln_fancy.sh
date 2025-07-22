test -e /b/l || mkdir /b/l
rm ${HOME}/l/*
find /home/b | grep -v 'RecentDocuments' | grep -E '/b[0-9]*_'$leaf | 
   bxargs 'echo -n ln -s \"{}\" ${HOME}/l/ | tee /ram/mklnpath.tmp; cat /ram/mklnpath.tmp | sed --regexp-extended "sO.*/b([0-9]*)_.*O\1Og"; echo' > /ram/mkln.sh
cat /ram/mkln.sh
#echo 'need to execute /ram/mkln.sh'
. /ram/mkln.sh
   #echo "{}"|sed --regexp-extended "s/e/x/g"
