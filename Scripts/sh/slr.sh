#echo 'now using .odt doc as master'

#return
####################### old
[ $# -eq 0 ] && isval "$(paste)" && { slr "$(paste)"; return; } #recursive
#good example howto of while loop with various test styles
sl=$(b 18)
#while [ $# -ge 1 ]; do
  [[ $(grep -cEi "$*" $sl) -ne 1 ]] && { grep -Ei "$*" $sl ; return 2; } 
  grep -Ei "$*" $sl >> /l/8/slbought.txt 
  echon 'removing ' && grep -Ei "$*" $sl && 
           grep -vEi "$*" $sl > /tmp/sltemp.txt && cp /tmp/sltemp.txt $sl
  return 0
#  shift 1
#done
