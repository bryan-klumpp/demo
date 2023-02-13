tomv="$1"; shift 1
sed --in-place --regexp-extended 's/(.*)([ ,;])('"$tomv"')(.*)/\3\2\1\4/' "$@"
