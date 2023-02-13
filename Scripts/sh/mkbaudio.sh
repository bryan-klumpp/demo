baudsh=/t/$(btime)_mkbaudio.sh
echo '' > $baudsh
grep -iE '\.wav$'|ug _baud[0-9]*_ | bxargs 'bash /b/l/1/mkbaudiox.sh {} >> '$baudsh
cat $baudsh
echo -n $baudsh | clip
echo $baudsh 
