fcr='^'
isval $1 && fcr="$@"
cat $(b 19)/*txt|grep -E "$fcr"|j fcout|tee /t/fc|grep -E "$fcr"   #the last just for coloring
