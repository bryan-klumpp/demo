test -L "$1" && return  #symbolic links are trouble
parent=$(echo -n "$1" | sed --regexp-extended 's#(.*)/([^/]*)$#\1#')
 child=$(echo -n "$1" | sed --regexp-extended 's#(.*)/([^/]*)$#\2#')
echo child:$child
newname="$parent/$(echo -n "$child" | sed 's/ /_/g')"
echo "/bin/mv -T --no-clobber '$1' '$newname'" 


