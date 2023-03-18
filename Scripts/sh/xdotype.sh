isint $1 && { sleep $1; shift 1; }
xdotool type "$*"