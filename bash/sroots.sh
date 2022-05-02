#test -d $shdir || shdir=/b/l/1
#echo "$shdir"/$1".sh" "$@"
#. /b/l/1/generated_functions.sh
bash -c ". /b/l/1/generated_functions.sh ; . /b/l/1/$1.sh" "$@"
exit
#return
########################################
test -z $BASH || . $shdir/generated_functions.sh
base=$shdir/$1
shift 1
if test -f $base.sh; then . $base.sh "$@"; elif test -f $base; then . $base "$@"; else { echo "script $base not found"; bex 1; }; fi
#do not add anything after execution so we can preserve return value to be used as ex_t value
