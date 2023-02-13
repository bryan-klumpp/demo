jnlfile=$(b 3)/dated/$(bdate)_journal.txt
isval $1 || { cat $jnlfile; return; }
mytime=$(btime)
echo >> $jnlfile
jnlentry="$*"
echo -n "$mytime $*"|tr ^ "'" >> $jnlfile ; tail -n 1 $jnlfile |grep -E $mytime'.*$|^' ; 
#c 1
#clear
Co "$jnlentry" '(^|\W)-[A-Z][a-z]' && { sleep 3; clear; }
