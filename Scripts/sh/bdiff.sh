left="$(can "$1")"
right="$(can "$2")"
difffile=/tmp/"$(btime)"_bdiff_"$(tofilename "$left")"
echo 'diff of '$left' and '$right > $difffile
{ sd diff --no-dereference --brief --recursive --binary "$left" "$right" 2>&1; echo $? > /tmp/diffret; } | 
    grep -vE 'is a fifo.*is a fifo' | tee -a "$difffile"
grep -qE '^0$' /tmp/diffret && echo 'no differences!' || echo 'differences?'
echo 'see '$difffile
return $(cat /tmp/diffret)

#sanity checking
rm "$left"/deleteme* "$right"/deleteme* &> /dev/null
echo asdf1 >  "$left"/deleteme_tf1.txt
echo asdf2 > "$right"/deleteme_tf1.txt
echo asdf3 >  "$left"/deleteme_oil.txt 
