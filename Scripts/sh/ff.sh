#first="$1"; shift 1
#freg="$(echo -n "$*" | tr ' ' '.')"


#f "$1"$leaf


find -mindepth 1 |sed --regexp-extended 's#^\./##g' | gg "$@" #sort --reverse
