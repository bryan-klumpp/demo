[ $# -eq 0 ] && { c /b; return; }
###### obsolete: [ $1 -eq 1 ] && { test -d /l/1 || { echo /sh; return; } } #special case make sure scripts run cached if necessary
invalidlink=''; readlink /l/$1 && return || { 
  invalidlink='true'; err 'INVALID_B_LINK_b'$1'_*; will exit after 5 seconds...'; sleep 0; return 99; }  #getting some junk so taking slightly drastic step of exiting...
isval $invalidlink && exit 99

isint $1 && { readlink -e /l/$1; return; }
lsln | grep "$1"; return


test -e /l/$1 && { echo readlink -e /l/$1; return; }
newfound=/home/b/**/b$1_*
test -z newfound || bln #found in different location; may as well redo all links at once
echo $newfound
