# this line is ridiculous, not sure when it stopped working but it's going to STAY not working	[[ $1 =~ ^[[:digit:]]{1,}$ ]] && return 0 || return 1   #much trial and error was involved to get this working.  grep -c or grep using return code would have been possible alternatives
isval $2 && maxdigits=$2 || maxdigits=50
[[ $1 =~ ^[[:digit:]]{1,$maxdigits}$ ]] && { #echo 'isint ###'$1'###yes'; 
return 0; } || { #echo 'isint ###'$1'###NO'; 
return 1;}
