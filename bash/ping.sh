not isval $1 && { /bin/ping -c 1 www.google.com|grep '1 received'; return; }
isint $1 && { /bin/ping 192.168.254.$1; return; }
/bin/ping "$@"
