[ $# -eq 0 ] && { bd; return; }    # { echo 'please use c if you want a directory listing'; return; }
[ $# -eq 1 ] && { ls -l | g "$1"; return; }
mdd "$*" 
