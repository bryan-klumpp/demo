x=1920; y=987
modename=$(echo "$(gtf $x $y 60)" | grep -oE '\".*\"' | sed --regexp-extended 's/\"//g')
xrandr --newmode $(gtf $x $y 60 | grep -oE '\".*' | sed --regexp-extended 's/\"//g')
xrandr --addmode Virtual1 "$modename"
xrandr --output Virtual1 --mode "$modename"
