shr=$(b 1)/gen
echo -n '' | tee "$shr"1.sh | tee "$shr"2.sh | tee "$shr"3.sh  #create or erase base files for appending
find $(pwd) | mkmp3c
