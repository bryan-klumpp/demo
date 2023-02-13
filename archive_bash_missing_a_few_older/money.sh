f88=$1
isval f88 || f88='<(paste)'
grep --no-filename -o '\$[0-9]*' "$f88" |tr '$' ' ' |add