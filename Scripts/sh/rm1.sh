[ $# -eq 1 ] || { echo 'incorrect number of parameters: '"$@"; return 92; }

brm "$1"
