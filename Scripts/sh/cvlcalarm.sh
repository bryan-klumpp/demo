eq $# 0 && { echo 'usage: cvlcalarm 1 30'; return; }
isval $1 && { sleephr $1; sleepmin $2; }
true
while eq $? 0; do cvlc /l/90; done
