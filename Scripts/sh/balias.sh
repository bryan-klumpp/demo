af=${HOME}/l/21
[ $# -eq 0 ] && { te $af; . $af; return; }
key=$1; shift 1
line="alias $key='$*'"
echo "$line" | tee -a $af
. $af


#alias $key="'$*'" #"$line" #seems to have quote problem
