#c /b/audio/alarm
#echo -n 'sample command: ' ; echo -n 'sleepmin $((60*6+15));cvlc --loop b16_* #cvlc --longhelp --advanced -H' | tee >(clip) ; echo
#cvlc --loop $(b 16) #cvlc --longhelp --advanced -H' | tee >(clip)

echo $(btimes);
snd 
jav b.Greed0.Alarm "$@"&
