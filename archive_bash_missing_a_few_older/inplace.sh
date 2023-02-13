[ $# -eq 0 ] && { echo "example: inplace 's/0high/Need9/g' \$(b 18)" ; return; } 
sed --regexp-extended -i.deleteme$(btime) "$@"
