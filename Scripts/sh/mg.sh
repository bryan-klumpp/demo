[ $# -eq 1 ] && {                               gg "$1" -i --color=always  ; return; }
[ $# -eq 2 ] && { gg "$1" -i --color=always   | gg "$2" -i --color=always  ; return; }
[ $# -eq 3 ] && { gg "$1" -i --color=always   | gg "$2" -i --color=always    |
                  gg "$3" -i --color=always                               ; return; }
[ $# -eq 4 ] && { gg "$1" -i --color=always   | gg "$2" -i --color=always    |
                  gg "$3" -i --color=always   | gg "$4" -i --color=always  ; return; }
[ $# -eq 5 ] && { gg "$1" -i --color=always   | gg "$2" -i --color=always    |
                  gg "$3" -i --color=always   | gg "$4" -i --color=always    |
                  gg "$5" -i --color=always                               ; return; }
[ $# -eq 6 ] && { gg "$1" -i --color=always   | gg "$2" -i --color=always    |
                  gg "$3" -i --color=always   | gg "$4" -i --color=always    |
                  gg "$5" -i --color=always   | gg "$6" -i --color=always  ; return; }
