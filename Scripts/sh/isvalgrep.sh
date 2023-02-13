#[[ $1 =~ .{1,} ]] && return 0 || return 1
#echo 'please please why is this so hard? $1='$1
#echo 'isval ###'$1'###'
echo $1|grep '.' > /dev/null && { #echo 'isval ###'$1'###yes';
 return 0; } || { #echo 'isval ###'$1'###NO';
 return 1; }
