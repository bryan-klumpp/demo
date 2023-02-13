#grep -q "$2" <(echo -n "$1")
[[ "$1" =~ "$2" ]] # && { return 0; }
#return 1