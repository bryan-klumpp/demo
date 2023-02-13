for nf; do {
  { test -L "$nf" || ! test -f "$nf"; } && continue  #must not be a file, abort but return 0.  Performance concession
  i=$(stat --printf='%i' "$nf")
  test -e h/$i || ln "$nf" h/$i
}; done