refdir="$2"
test -z "$refdir" && refdir="$(cat /ram/var/refdir)"   #just in case $2 refdir not passed

test -f "$1" || exit 0      #only process real files

echo 'rm '$(. $(shpath)/esc.sh "$1") >> /t/deletemissingdebug.sh  #debugging
test -f "$refdir/$1" || echo 'rm '$(. $(shpath)/esc.sh "$1") >> /t/deletemissing.sh
