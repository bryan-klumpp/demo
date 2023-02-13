! [ $# -gt 0 ] && { cd "$(readlink -e "$(pwd)")"; setwd; return; }
readlink -e "$1"