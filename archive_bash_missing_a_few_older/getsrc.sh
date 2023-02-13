pkg=$1
echo 'downloading source for '"$pkg"
pkgo=$(echo -n "$pkg" | grep -oE '^[^/]*')
pn=$(echo -n "$pkg" | sed -E 's/(.*)( amd64| all).*$/\1\2/' | tr '/' '_')
#apt-get source $pkg || break
echo -n $pkgo; echo ...."$pn"
