mntkt || return
cp -a "$@" /b/kt
sd umount /b/kt && sync && echo 'unmounted and synced'
