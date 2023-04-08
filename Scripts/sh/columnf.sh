cat - > /tmp/columnfin
# cat /tmp/columnfin
delim='|'
cat /tmp/columnfin | head -n 1 | sed --r 's/\t/TAAAB/g' | tr ' ' '@' > /tmp/columnfs2
tail -n +2 /tmp/columnfin | sed --r 's/\t/TAAAB/g' >> /tmp/columnfs2
cat /tmp/columnfs2 | column -s $delim -o $delim -t /b/t/s2 | sed --r 's/TAAAB/\t/g' | tail -n +2


#delim='|'; cat /b/t/in; cat /b/t/in | head -n 1 | tr '\t' '!' | tr ' ' '@'| sed --regexp-extended "s/@([${delim}])@?/ \1 /g" > /b/t/s2; tail -n +2 /b/t/in >> /b/t/s2; echo; echo; echo -n '>'; cat /b/t/s2; echo '<'; echo; column --table /b/t/s2
#sorta working: delim='|'; cat /b/t/in; cat /b/t/in | head -n 1 | sed --regexp-extended 's/\t/{TAB}/g' | tr ' ' '@' | sed --regexp-extended 's/@['$delim']/ '$delim'/g' > /b/t/s2; tail -n +2 /b/t/in >> /b/t/s2; echo; echo; echo -n '>'; cat /b/t/s2; echo '<'; echo; column -s $delim -t /b/t/s2

#REEEEEEEEEEEEALY close:  delim='|'; cat /b/t/in; cat /b/t/in | head -n 1 | sed --regexp-extended 's/\t/{TAB}/g' | tr ' ' '@' | sed --regexp-extended 's/@['$delim']/ '$delim'/g' > /b/t/s2; tail -n +2 /b/t/in >> /b/t/s2; echo; echo; echo -n '>'; cat /b/t/s2; echo '<'; echo; column -s $delim -o $delim -t /b/t/s2

#REEEEEEEEEEEEALY closer: delim='|'; cat /b/t/in; cat /b/t/in | head -n 1 | sed --regexp-extended 's/\t/TAAAB/g' | tr ' ' '@' | sed --regexp-extended 's/@['$delim']/ '$delim'/g' > /b/t/s2; tail -n +2 /b/t/in | sed --regexp-extended 's/\t/TAAAB/g' >> /b/t/s2; echo; echo; echo -n '>'; cat /b/t/s2; echo '<'; echo; column -s $delim -o $delim -t /b/t/s2

# GOTIT delim='|'; cat /b/t/in; cat /b/t/in | head -n 1 | sed --regexp-extended 's/\t/TAAAB/g' | tr ' ' '@' > /b/t/s2; tail -n +2 /b/t/in | sed --regexp-extended 's/\t/TAAAB/g' >> /b/t/s2; echo; echo; echo -n '>'; cat /b/t/s2; echo '<'; echo; column -s $delim -o $delim -t /b/t/s2


return

| header1 | header2         | header3                           |
| data1 | data2222222222222222222222222 | data3 |

delim='|'; cat /tmp/in | head -n 1 | tr ' ' '.'| sed --regexp-extended "s/\.?[${delim}]\.?/ ${delim} /g"

#not there yet delim='|'; cat /b/t/in; cat /b/t/in | head -n 1 | tr ' ' '.'| sed --regexp-extended "s/\.?[${delim}]\.?/  /g" > /b/t/s2; echo >> /b/t/s2; tail -n +2 /b/t/in >> /b/t/s2; column --table -o " ${delim} " /b/t/s2

