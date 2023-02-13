sl=$(b 18)

cp $sl $(b 22)/archive/$(btime)_sl.txt  #optional - archive dir may not be available

test -e $sl &&
/bin/mv $sl /b/t/sl.txt &&
sort /b/t/sl.txt | grep -v xxx > $sl &&   #note: removing xxx meaning bought already
/bin/mv /b/t/sl.txt /b/t/slarchive.txt
sl
