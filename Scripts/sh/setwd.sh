wd=$(can $(pwd))
test -f ${HOME}/b14_wd.txt || { echo -n "$wd" > ${HOME}/b14_wd.txt && bln1 ~; return; }
echo -n "$wd" > ${HOME}/b14_wd.txt
