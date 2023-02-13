co "$(pwd)" '^/4' && c /
sync
/sh/um4.sh
sync
err 'check: '; ls /4
