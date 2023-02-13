parms="$@"
! isval $1 && parms=83294235480723489237   #kind of a hack but if no parms just choose a b that will probably be never matched
nocolor | #does not yet handle color properly so nuking color first
grep -vE $( echo -n "$parms" | 
  sed --regexp-extended 's#[0-9]*#(^|/)b\0_#g' | 
  sed --regexp-extended 's/ /|/g' \
) 
