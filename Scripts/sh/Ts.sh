bdir="$(pwd)"
############################below caution - bug if unintended direct subdirectory is same as search string and you get -i as search string.  Don't really need to to search in other than current directory anyway
co "$1" '^/' && test -e "$1" && { bdir="$1"; shift 1; } 
searchstringraw="$1"
searchstring=$(echo -n "$1"|esc); shift 1
therest="$@"
############################-print0
find -H "$bdir" | sort | trzero | grep -viE --null-data -f "$(b 5)" \
      | esc \
      | xargs -i -r -0 sh -c ' {
	   filename={}  
           #echo searching "$filename"
           ! test -f "$filename" && exit;	  
           grep -H -E -I -n --color=auto '"$@"' -e '"$searchstring"' "$filename"
      }'
echo --------- Now searching file list itself ---------------
find -H "$bdir"| sort | grep -E "$searchstringraw$leaf" "$therest"  | grep -E --color=auto -e "$searchstringraw" "$therest" 
echo ----------------- done searching -----------------------





return #####################################################################
#           '{ filename="{}"
#           test -d "$filename" && bex;
#           echo searching "$filename"
#           grep -H -E --color=auto --group-separator=------------------------------------------------------------------------------ \
#           -e "$searchstring" $* "$filename" ; }"  single quotes are to escape the dollar signs in file names like java classnames
# old way           '{ grep -H -E --color=auto --group-separator=------------------------------------------------------------------------------'\
# old way          "-e \"$searchstring\" ""$*"' {} }'
