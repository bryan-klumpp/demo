echo 'logging bln to /t/bln.log'
{ bln 2>&1 > /t/bln.log; } > /dev/null & disown
