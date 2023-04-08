echo 'asdf' > /tmp/cfcwashere$RANDOM$RANDOM
xclip -o -selection clipboard > /tmp/cfcin
cat /tmp/cfcin | /sh/columnf.sh > /tmp/cfcout
cat /tmp/cfcout | xclip -i -selection clipboard
#xdotool getactivewindow key ctrl+v
xdotool key ctrl+v
