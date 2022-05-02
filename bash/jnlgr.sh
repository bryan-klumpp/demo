bdir=/l/3/dated
searchstringraw="$1"
bdebug 'before setting searchString $1='$1
searchstring=$(echo -n "$1"|esc); shift 1
bdebug 'after setting searchString $1='$1
#-print0
find -H "$bdir" | grep -E '/2021' | sort | trzero | grep -viE --null-data -f $(b 5) \
      | esc \
      | xargs -i -r -0 sh -c ' {
	   filename={}  
           #echo searching "$filename"
           ! test -f "$filename" && exit;	  
           grep -H -E -i --color=always '"$@"' \
            -e '"$searchstring"' "$filename"
      }'
bdebug afterfind
echo --------- Now searching file list itself ---------------
find -H "$bdir"| sort | grep -E --color=always -e "$searchstringraw" 
echo ----------------- done searching -----------------------





