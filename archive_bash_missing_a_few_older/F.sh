#first="$1"; shift 1
find -mindepth 1 |sed --regexp-extended 's#^\./##g' | G "$@" #sort --reverse
