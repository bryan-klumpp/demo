[ $# -eq 0 ] && { echo usage: 812 161.23 \'... \' ; return; }
num=$1; shift 1
amt=$1; shift 1
co $amt '\.' || { echo 'amount not given'; return 111; }
mkdir 'check #'$num' $'$amt' '"$@"
d  #ll 'check #'$num*
