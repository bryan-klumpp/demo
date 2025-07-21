#find /sh/* -maxdepth 1 | sed -E 's_^/sh/(.*)\.sh$_\1_' | sed -E 's_.*_alias \0='\''. /sh/\0.sh'\'_ > /sh/b2323_*
shpath=$(readlink -e /c/b/code/demo/Scripts/sh)
find "$shpath" -maxdepth 1 -type f -printf "%f\n" | sed -E 's_^(.*)\.sh$_\1_' | sed -E 's_.*_function \0() { . '"$shpath"'/\0.sh "$@"; }_'         >> "$shpath"/generated_functions.sh
# find $(readlink -e /sh) -maxdepth 1 -type f -printf "%f\n" | sed -E 's_^(.*)\.sh$_\1_' | sed -E 's_.*_function \0() { . '"$shpath"'/\0.sh "$@"; }_' > "$shpath"/generated_functions.sh
#cat "$shpath"/b2323_* #just for debugging
. "$shpath"/generated_functions.sh
