#isval $1 && { te $(b 3)/dated/$1_journal.txt; return; }
jnlfile=$(b 3)/dated/$(btime)_"$*"_journal.txt
echo "$(btime) $*" >> "$jnlfile" && 
  nano --syntax=none "$jnlfile";
