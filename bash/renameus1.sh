test -L "$1" && return 0  #ignore symbolic links
co ' ' "$1" || return 0 #if no space we don't care
parent=$(echo -n "$1" | sed --regexp-extended 's#(.*/)?([^/]*)$#\1#')
 child=$(echo -n "$1" | sed --regexp-extended 's#(.*/)?([^/]*)$#\2#')
newname="$parent$(echo -n "$child" | sed 's/ /_/g')"
echo "/bin/mv -T --no-clobber '$1' '$newname'" 


