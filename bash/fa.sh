# $1=grep string, $2=find options
#canonicalize-existing readlink -e   or even better realpath -e --no-symlinks
results=$(find "$(wdc)" -mindepth 1 $2 2>/tmp/err.txt |grep -iE --color=auto "$1")
fretcode=$?
echon "$results"|sort; cat /tmp/err.txt|grep -viE \
  '(destop.ini|ntldr|ntdetect|hiberfil|ntuser|usrclass.dat|bootmgr|cmldr|'$gs').*Permission Denied';  #-maxdepth 500
return $fretcode
