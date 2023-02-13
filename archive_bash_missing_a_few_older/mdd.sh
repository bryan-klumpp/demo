newdir="$(underscore "$*")"
mkdir "$newdir" || return 82
a bln1 "$newdir"
echo -n 'created directory (clipboard): '; echo "$newdir"|g '.*'
echo -n "$newdir" | clip
