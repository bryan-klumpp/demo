[[ $# -ge 1 ]] && {
  f="$(underscore "$*")"
#  not test -f "$f" && { [[ "$f" =~ '.*odt' ]] || f="$f".odt; }  #force odt extension if $1 does not exist
  not test -f "$f" && { not gi "$f" '.*odt' && f="$f".odt; }  #force odt extension if $1 does not exist - compatibility
  not test -f "$f" && cp $(b 26)/lowriter.odt "$f"
  a lowriter "$f"
  return
}
a lowriter
