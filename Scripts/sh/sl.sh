shop; return


sl=$(b 18)
[ $# -eq 0 ] && { cat $sl | sort ; return; }
[ $# -eq 1 ] && isint $1 && { slg 'Need[56789]'; return; }
[ $# -eq 1 ] && { slg "$@"; return; }
cat $sl|grep -iE "$*" || { echo "$*" >> $sl; }   #check one last time for existing match
echo -n added: ; cat /l/18|tail -n 1   #|gc '^.*$'

return
##########3

[ $# -ge 1 ] && { 
td=/tmp/$(btime)_search
mkdir $td
{ unzip -d $td /l/1818; } 2>&1 > /tmp/sl_extract.log
grep -oE --color=always '[^>]*'"$*"'[^<]*' $td/content.xml
rm -R $td
return
}

o $(b 1818)



######################################### below obsolete text stuff
return 
