###name stands for move cheese no clobber - not sure why just for cheese

test $# -le 2 || { echo 'too many parms to mvnoclobber'; return 38; }
test -e "$1" || return 0 #nothing more to do
isempty "$1" && return 0 #nothing more to do
/bin/mv --no-clobber --verbose "$1"/* $2  #the isempty test is just to suppress error messages
isempty "$1" || { echo 'possible duplicate filenames; '"$1"' is not empty'; return 92; }
