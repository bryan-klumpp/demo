
#permval=$(paste)
clip
sleep 1
#thesame "$(paste)" "$permval" && ! test -z $permval && { err 'You seem to have run cliptmp too often; aborting'; return 111; }
{ sleep 60; echo -n "x" | clip; } &
echo 'you have 60 seconds to use value on clipboard'
