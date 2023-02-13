# this line is ridiculous, not sure when it stopped working but it's going to STAY not working	[[ $1 =~ ^[[:digit:]]{1,}$ ]] && return 0 || return 1   #much trial and error was involved to get this working.  grep -c or grep using return code would have been possible alternatives
echo $2|grep '.' > /dev/null && maxdigits=$2 || maxdigits=999
echo -n $1|grep -E '^[[:digit:]]{1,'$maxdigits'}$' >/dev/null && { #echo 'isint ###'$1'###yes'; 
return 0; } || { #echo 'isint ###'$1'###NO'; 
return 1;}
