refdir="$2"
test -z "$refdir" && refdir="$(cat /ram/var/refdir)"   #just in case $2 refdir not passed

test -f "$1" || {
  test -d "$1" || exit 0
  test -d "$refdir/$1" || echo 'rmdir '$($(shpath)/escx.sh "$1") >> /t/deletemissingdirs.sh
  exit #processed directory, skip file processing
}

#echo 'rm '$($(shpath)/escx.sh "$1") >> /t/deletemissingdebug.sh  #debugging
test -f "$refdir/$1" || echo 'rm '$($(shpath)/escx.sh "$1") >> /t/deletemissing.sh
