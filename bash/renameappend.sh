appendstring=_"$(tofilename "$1")"; shift 1
rename -v 's/$/'"$appendstring"/ "$@"
for next; do bln1 "$next"; done
