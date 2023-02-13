test -e /tmp/var || mkdir /tmp/var
[ $# -eq 0 ] && { ls /tmp/var | sort | bxargs 'echo {}=$(cat /tmp/var/{})'; return; }
[ $# -eq 1 ] && { 
  varval="$(cat /tmp/var/$1)"
  test -z "$varval" && { echo 'missing variable '$1'; aborting in 5...'; sleep 5; exit 66; }
  echo -n "$varval"
  return; 
}
declare -x -g $1="$2"
export $1="$2"
bsetscriptfile=/tmp/$RANDOM$RANDOM.sh
echo -n "$1=" > $bsetscriptfile
echo "$2" | esc >> $bsetscriptfile
. $bsetscriptfile
rm $bsetscriptfile
echo -n "$2" > /tmp/"$1"
