function xdox() {
  if [ $XDG_SESSION_TYPE != x11 ]; then {
    echo 'You are probably running Wayland; xdotool will not work on Wayland.  Log out, click your user id, choose the gear icon, and choose "Ubuntu on X"' > /dev/stderr
  } fi
  sleep $1; shift 1
  xdocmd=$1; shift 1
  /usr/bin/xdotool $xdocmd "$@"
}
