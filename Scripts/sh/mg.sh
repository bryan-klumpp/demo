[ $# -eq 1 ] && {                              G "$1" -i --color=always  ; return; }
[ $# -eq 2 ] && { G "$1" -i --color=always   | G "$2" -i --color=always  ; return; }
[ $# -eq 3 ] && { G "$1" -i --color=always   | G "$2" -i --color=always    |
                  G "$3" -i --color=always                               ; return; }
[ $# -eq 4 ] && { G "$1" -i --color=always   | G "$2" -i --color=always    |
                  G "$3" -i --color=always   | G "$4" -i --color=always  ; return; }
[ $# -eq 5 ] && { G "$1" -i --color=always   | G "$2" -i --color=always    |
                  G "$3" -i --color=always   | G "$4" -i --color=always    |
                  G "$5" -i --color=always                               ; return; }
[ $# -eq 6 ] && { G "$1" -i --color=always   | G "$2" -i --color=always    |
                  G "$3" -i --color=always   | G "$4" -i --color=always    |
                  G "$5" -i --color=always   | G "$6" -i --color=always  ; return; }
