#set -x
app=nautilus
which $app || app=pcmanfm
dir=$1
isval "$dir" || dir="$(can $(pwd))"
a $app "$dir"
#set +x
