#############################################################echo -n "$*" | grep -E '^[0-9]{1,}( [0-9]{1,}){1,}$' && { mvb "$@"; return; } #special case mvb but just invoke it manually please
#co "$(pwd)" '^/4' || co "$(pwd)" '^/sh' || { echo are you in a valid /4 move location??; echo mv "$@" >> mv_TODO_mv_on_master_4_path.sh; return; } 
############################################################# normal move
#############################################################co "$(readlink -e "$(pwd)")" /media/b/4t || { echo 'do not mv if not on 4t'; return 82; }
/bin/mv --verbose --no-clobber "$@"; retcd=$?
bln1 "$2"  #update links; won't work for multiple source files but that's rare
############################################################# risky due to multiple master locations ## echo -n "$2" | grep -E '(^|/)b[0-9]{1,}_' && { bln1 "$2" | nl; }  #update /l symlinks TODO make this last parameter and not hardcoded to $2
return $retcd


#
