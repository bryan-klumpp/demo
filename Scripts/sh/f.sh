#first="$1"; shift 1
#freg="$(echo -n "$*" | tr ' ' '.')"
if [ $# -eq 0 ] ; then
    find "$(pwd)"
else
    find "$(pwd)" -mindepth 1 2>/dev/null |sed --regexp-extended 's#^\./##g' | mg "$@" #sort --reverse
fi
