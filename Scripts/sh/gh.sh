regex="$1"; shift 1
g '^|'"$1" "$@"
