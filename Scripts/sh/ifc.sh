[ $# -eq 0 ] && { ifconfig -a | g "192.|flags|packets"; return; }
ifconfig "$@"
