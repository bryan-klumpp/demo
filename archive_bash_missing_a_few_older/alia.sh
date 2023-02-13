return #no worky

af=$(b 21)
cat $af | grep -v $1'=' > $af
unalias $1
