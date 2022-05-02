/usr/bin/sudo -K
echo 'requesting sudo password for: '"$@"
/usr/bin/sudo "$@"
/usr/bin/sudo -K
