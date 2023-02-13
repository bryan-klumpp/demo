isint "$1" || { echo 'usage: prompt> 123 this is a directory name'; return; }
success=''
i=$1; shift 1

while true; do {
  ! test -L /l/$i && { success='true'; break; } 
  i=$(( $i + 1 ))
} done

newfn=b"$i"_"$*"
#test -e "$*" && { mv "$*" "$newfn"; return; } #file already exists - but not sure what this was doing, might have been responsible for duplicated nested links
md "$newfn"
