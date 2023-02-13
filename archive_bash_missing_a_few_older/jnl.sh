mytime=$(btime)
jnlfile=$(b 3)/dated/"$mytime"_journal.txt
jnlentry="$*"
test -f "$jnlentry" && jnlentry="$(cat "$jnlentry")"  #if passed a file, extract text
echo -n "$mytime $jnlentry" | trim >> $jnlfile ; cat $jnlfile | trim | 
         grep -E --color=auto "$mytime|^" ; ###echo...|tr ^ "'" what was that all about?
Co "$jnlentry" '(^|\W)-[A-Z][a-z]' && { sleep 3; rm ~/.bash_history; clear; }
