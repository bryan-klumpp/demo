cat /b/f | g "$@"

return ##################################3

cat /l/8/file_list/* | g "$@"


return #################################3

{ test -e /b/f && cat /b/f; } | 
   mast | mg "$@"


return

fcr='^'
isval $1 && fcr="$@"
{ cat $(b 19)/media6*txt; } |
  mg "$fcr"|nocolor|j fcout|tee /tmp/fc|mg "$fcr"   #the last just for coloring
