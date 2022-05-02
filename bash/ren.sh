
#warning that rename is only safe on master drive
co "$(readlink -e "$(pwd)")" /media/b/4t || { echo 'do not mv if not on 4t'; return 82; }

unalias rename
rename "$@"
alias rename 'echo unsafe; see ren'
