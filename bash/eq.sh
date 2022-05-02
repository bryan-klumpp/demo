isval $3 && echo 'too many arguments passed to isequal()' && return 3
if [[ $1 = $2 ]] ; then
	return 0
else
	return 1
fi		

