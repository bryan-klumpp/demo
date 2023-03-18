#find /sh/* -maxdepth 1 | sed -E 's_^/sh/(.*)\.sh$_\1_' | sed -E 's_.*_alias \0='\''. /sh/\0.sh'\'_ > /sh/b2323_*
shpath=$(readlink -e /sh)
#find $(readlink -e /sh) -maxdepth 1 -type f -printf "%f\n" | sed -E 's_^(.*)\.sh$_\1_' | sed -E 's_.*_function \0() { . /sh/\0.sh "$@"; }_'         >> /sh/b2323_generated_functions.sh
find $(readlink -e /sh) -maxdepth 1 -type f -printf "%f\n" | sed -E 's_^(.*)\.sh$_\1_' | sed -E 's_.*_function \0() { . /sh/\0.sh "$@"; }_' >> /sh/generated_functions.sh
#cat /sh/b2323_* #just for debugging
. /sh/generated_functions.sh
