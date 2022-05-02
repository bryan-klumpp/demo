#co "$(readlink -e "$(pwd)")" /media/b/4t || co "$1" /tmp/ || { echo 'tried to rm '"$@"; echo 'do not rm if not on 4t'; return 82; }
/bin/rm "$@"; retcd=$?

return $retcd
