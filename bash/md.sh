newdir="$(underscore "$*")"
mkdir "$newdir" || return 82
cd "$newdir" && bd
bln1 "$(pwd)"
echo -n 'created directory: '; echo "$newdir" | highlight
