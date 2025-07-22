#echo BROKE; return 33;

#[ $# -eq 0 ] && { echo "usage: prompt> deletemissing /a/refdir   #will delete files in current working tree'; return; }

#echo -n "$1" > /ram/var/refdir; test -d "$1" || return 88;


escapedref="$(esc "$1")"
echo "cd $(pwd) || return 39" | tee /t/deletemissingdirs.sh > /t/deletemissing.sh #overwrite create new output batches
f|bxargs '. $(shpath)/deletemissingx.sh {} '"$escapedref"
cat /t/deletemissingdirs.sh | tros >> /t/deletemissing.sh
echo -n '. /t/deletemissing.sh' | clip
cat /t/deletemissing.sh
