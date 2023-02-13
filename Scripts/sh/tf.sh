file=/t/$(/b/sh/btime.sh)_tmpfile.txt
$@ > $file
echo "wrote output to $file"