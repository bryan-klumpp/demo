shr=$(b 1)/gen
grep -iE '_baud[0-9]*[^/]*\.wav$' | bxargs 'bash /b/l/1/mkmp3x2.sh {}' > /tmp/gen1.sh 
#split -l 100 /tmp/genall.sh
cat /tmp/gen1.sh | l
echo 'see /tmp/gen1.sh (exec copied to clipboard)'
clip '. /tmp/gen1.sh'



#echo -n "$mp3sh" | clip
#echo "$mp3sh" 

