mount | grep "$1" && { echo mounted!!!; return 1; exit 1; }

sd badblocks -vws -t 0x$2 -b 4194304 "$1"