for next; do {
  test -d "$next" && { rmdir "$next" || return; continue; }  
  rm "$next" && echo 'removed '$(can "$next") || return
} done


return
#try to save in rash
[ $# -eq 1 ] || { err 'wrong number of parameters to brm';return 111; }
trashdir=/b/trash/$(btime)
mkdir "$trashdir"
m "$1" $trashdir   #--no-clobber
