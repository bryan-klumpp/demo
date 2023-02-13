#see rsp.sh - dangerous
extflag=nocopy/nocopyexternaldriveflag.txt
echo "$1" > /t/to; shift 1
echo false > /t/commit; echo false > /t/deleteafter
MS=$(echo -n $(date +%M%S))
for parm; do { 
  [[ $parm == 'commit' ]] && { echo true > /t/commit; continue; } 
  [[ $parm -eq $MS ]] && { echo true > /t/deleteafter; continue; } 
} done #less fancy for loop code generation - see archive
echo 'set -x' > /t/brscommit.sh
rel|bxargs '
  to=$(cat /t/to); commit=$(cat /t/commit); deleteafter=$(cat /t/deleteafter)
  src=$(pwd)/{}
  dst=$(cat /t/to)/{}
  brsadd1 $src $dst
true'
echo 'set +x' > /t/brscommit.sh
cat /t/brscommit.sh
echo 'execute /t/brscommit.sh if looks ok'
