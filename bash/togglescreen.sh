! xrandr | grep --silent 'current 320 x 200' && { xrandr --output eDP-1 --off; exit; }
xrandr --output eDP-1 --auto
