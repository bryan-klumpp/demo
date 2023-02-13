pf="$*"
isval $pf || pf="$(paste)"
test -e "$pf" && echo 'file exists: '$pf || echo 'file missing'
