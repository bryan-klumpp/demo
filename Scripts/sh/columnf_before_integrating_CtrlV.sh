cat - > /tmp/columnfin
# cat /tmp/columnfin
delim='|'
cat /tmp/columnfin | head -n 1 | sed --r 's/\t/TAAAB/g' | tr ' ' '@' > /tmp/columnfs2
tail -n +2 /tmp/columnfin | sed --r 's/\t/TAAAB/g' >> /tmp/columnfs2
cat /tmp/columnfs2 | column -s $delim -o $delim -t /b/t/s2 | sed --r 's/TAAAB/\t/g' | tail -n +2
