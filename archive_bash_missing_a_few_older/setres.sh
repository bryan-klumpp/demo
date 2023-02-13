x=$1; y=$2
modename=$(echo "$(cvt -r $x $y)" | grep -oE '\".*\"' | sed --regexp-extended 's/\"//g')  #cvt -r for less whitespace
xrandr --newmode $(cvt -r $x $y | grep -oE '\".*' | sed --regexp-extended 's/\"//g')  
xrandr --addmode HDMI-1 "$modename"
xrandr --output HDMI-1 --mode "$modename"
