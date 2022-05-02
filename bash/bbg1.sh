[ $# -eq 0 ]  && { bbg1 $(btime)$RANDOM$RANDOM; return; } #recursive

{ #run the rest all behind the scenes but logging output 

echo $1 > /tmp/bbgid.txt
i=0
while true; do {
  sleep 1
  i=$(( $i + 1 )) #increment loop counter

  [ $(( $i %     1 )) -eq 0 ] && { grep --silent $1 /tmp/bbgid.txt || break; }   #stop if a new process started
  [ $(( $i %     1 )) -eq 0 ] && temp
  [ $(( $i %  3000 )) -eq 0 ] && syncsh
  #scrot -q 1 --silent $(b 80)/$(btime)_screenshotgrab_ssg_lifelog_Greed3.jpg
  #scrot --silent $(b 80)/$(btime)_screenshotgrab_ssg_lifelog_Greed3.png
  #wcg
  #echo asdf > /media/b/5tb/keepalive
  #echo $(btime) finished
} done

} 2>&1 >> /tmp/bbg1.log

