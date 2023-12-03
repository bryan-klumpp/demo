 printf "%s\0" "$@" | shuf -z -n1 | tr -d '\0'
