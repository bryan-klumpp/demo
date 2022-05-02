#renamespec '[\x5C\x3A\x2A\x3F\x22\x3C\x3E\x7C]' '_'
from=$1
to=$2
! isval $to && { echo 'missing TO value'; return 88; }
tfl=/tmp/$(btime)_tfl
###find $(pwd) | grep -P "$from" > $tfl
find $(pwd) > $tfl
cat $tfl | { grep $to > /dev/null; } && { echo 'WARNING: target pattern exists; Ctrl+C in 5 seconds if thats bad'; sleep 5 || return 5; }
cat $tfl | dirs | sort --reverse > "$tfl"d
q="'"
scmdd="rename "$q"s/""$from"/"$to"/g"$q"" *"
scmdf="rename "$q"s/""$from"/"$to"/g"$q"
###echo -n $scmdf; echo '  !!!'
cat "$tfl"d | bxargs 'set -x && cd {} && '"$scmdd"
###find | sort --reverse | "$scmdf"  #no worky
find "$(pwd)" | grep -P "$from" | tee /tmp/whatsleft
