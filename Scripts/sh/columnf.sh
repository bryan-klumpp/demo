delim=$1

xclip -o -selection clipboard > /tmp/columnfin
head -n  1 /tmp/columnfin | tee /tmp/columnfline1     | sed -r 's/\t/TAAAB/g' | tr ' ' '@' > /tmp/columnfs2
tail -n +2 /tmp/columnfin | sed -r 's/ +/ /g'         | sed -r 's/\t/TAAAB/g'             >> /tmp/columnfs2
cat /tmp/columnfs2 | column -L -t -s $delim -o $delim | sed -r 's/TAAAB/\t/g' | tr '@' ' ' > /tmp/columnfs3
{ cat /tmp/columnfline1; cat /tmp/columnfs3 | tail -n +2 /tmp/columnfs3; } | xclip -i -selection clipboard
xdotool key ctrl+v
exit


		| col1                  |  col2    |  col3                                  |
		| data1    | data22222222222222222222222 | data3                                  |

		| col1    |  coffl2    |  col3                                  |
		| data1 | data22222222222222222222222 | data3 |

		| col1    |  col2    |  col3                                  |
		| data1 | data22222222222222222222222 | data3 |
