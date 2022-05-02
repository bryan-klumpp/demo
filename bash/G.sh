#commented 20180404 to allow searching on int #isint $1 && { C='-B '$1; shift 1; } || { C=''; }
#argsfor nextarg; do { grep -E -e '^-\w{1,}' &&  }
#isval $1 || { echo 'error, no pattern passed to G()'; return 2; }
#parameter order matters (if using $@), expression must be next arg due to -e and then optional parameters can follow
mygs='--group-separator='$gs; isval "$C" ||  mygs=''
tf=$(tmpfilename)
#Gsearchstring=$(echo -n "$*" | esed 's/ /.*/g')  #for future use when I work bugs out
grep -P --color=always $mygs "$@" > $tf #20180404
greturn=$?
numlines=$(cat $tf | count)
#[ $numlines -gt 15 ] && { cat $tf | less -R; } || cat $tf
cat $tf
test -f $tf && rm $tf


return $greturn ###########################################################
#------ following is fancy multi-grep stuff, see mg.sh also

isval $3 && { grep -E --color=always  -e "$1" |
              grep -E --color=always  -e "$2" |
              grep -E --color=always $mygs $C -e "$3"; return; }
isval $2 && { grep -E --color=always  -e "$1" |
              grep -E --color=always $mygs $C -e "$2"; return; }
isval $1 &&   grep -E --color=always $mygs $C -e "$1"
