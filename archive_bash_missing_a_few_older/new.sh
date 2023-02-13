jnl '<stuff>'"$*"'</stuff>'

return ### KEEP IT SIMPLE

newi=$(sql1 'select max(i) + 1 from b')
#isint $1 && { ga $1 $newi > /dev/null ; shift 1; }
echo asdf"$*"asdf
sql "insert into b(i,t) values ( "$newi", '""$*""')"; whereis $newi
