[[ $# -ge 1 ]] && {
  f=$*
  test -e "$f" || f=$(underscore $*)
  not test -f "$f" && { not co "$f" '\.ods$' && f="$f".ods; }  #force ods extension if arg does not exist - compatibility
  not test -f "$f" && cp $(b 26)/localc.ods "$f"  #26=templates
  a localc "$f"
  return
}
a localc
