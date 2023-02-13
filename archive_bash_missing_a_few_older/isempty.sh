! grep -E --silent '\S' <(ls "$*")   


return #tried and true method below
echo -n $(ls -d "$*") | grep -cE '[^[:space:]]' &> /dev/null  
[ $? -eq 0 ] && return 1
[ $? -ne 0 ] && return 0
