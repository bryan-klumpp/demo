searchstringraw="$1"
bdebug 'before setting searchString $1='$1
searchstring=$(echo -n "$1"|esc); shift 1
bdebug 'after setting searchString $1='$1
{
#for root add sudos, omit sort, and filter out /media and /mnt and always search from /
rm /tmp/err2
sudo find -P / 2>/tmp/err | grep -Ev '^/(mnt|media|tmp)/' | trzero | grep -viE --null-data -f $(b 5) \
      | esc \
      | xargs -i -r -0 sh -c ' {
	   filename={}  
           #echo searching "$filename"
           ! test -f "$filename" && exit;	  
           sudo grep -H -E '"$@"' \
            -e '"$searchstring"' "$filename" 2>>/tmp/err2
      }'
bdebug afterfind
echo --------- Now searching file list itself ---------------
sudo find / | grep -E --color=always -e "$searchstringraw" | sort 
echo ----------------- done searching -----------------------

} > /tmp/found  #& #this will always be slow so might want to background it



return #####################################################################
#           '{ filename="{}"
#           test -d "$filename" && bex;
#           echo searching "$filename"
#           grep -H -E --color=auto --group-separator=------------------------------------------------------------------------------ \
#           -e "$searchstring" $* "$filename" ; }"  single quotes are to escape the dollar signs in file names like java classnames
# old way           '{ grep -H -E --color=auto --group-separator=------------------------------------------------------------------------------'\
# old way          "-e \"$searchstring\" ""$*"' {} }'
