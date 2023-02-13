#first="$1"; shift 1
#freg="$(echo -n "$*" | tr ' ' '.')"
find "$(pwd)" -mindepth 1 2>/dev/null |sed --regexp-extended 's#^\./##g' | mg "$@" #sort --reverse
