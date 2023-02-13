last=$(ls -t /l/3/dated | head -n 1)
cat $last | tee >(clip)
rm $last
