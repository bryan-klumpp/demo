#cat - | tee >(xclip -selection primary)    >(xclip -selection secondary) >(xclip -i -selection CLIPBOARD) >(xclip -selection XA_PRIMARY) >(xclip -selection XA_SECONDARY) >(xclip -i -selection clipboard) > /dev/null
#cat - | tee >(xclip -i -selection CLIPBOARD) >(xclip -selection XA_PRIMARY) >(xclip -selection XA_SECONDARY)
#cat - | tee >(xclip -i -selection clipboard)
#echo -n 'clipping: '
isval "$1" && { echo -n "$@" | clip; return; } #recursive
nocolor | trim | tee >(xclip -i -selection clipboard) > /dev/null; 
