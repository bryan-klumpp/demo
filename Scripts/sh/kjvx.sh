test -z "$*" && { cat /l/1611; return; }
key="$*"
tfn=/tmp/kjvx.tmp
#diatheke -b KJV -o n -k "$key" | sed --null-data 's/\n:.*/\n/' > $tfn; l $tfn 
diatheke -b KJV -k "$key" | sed --null-data 's/\n:.*/\n/' > $tfn; cat $tfn 


	