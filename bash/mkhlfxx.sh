for ns; do {
  i="$(cat "$1" | grep -Eo '^[0-9]{1,}'"
  nf="$(cat "$ns"|sed --regexp-extended 's/^[0-9]{1,} (.*)$/\1/')"
  { test -L "$nf" || ! test -f "$nf"; } && continue  #must not be a file, abort but return 0.  Performance concession
  #i=$(stat --printf='%i' "$nf")
  #test -e h/$i || ln "$nf" h/$i
  echo i="$i" nf="$nf"
}; done