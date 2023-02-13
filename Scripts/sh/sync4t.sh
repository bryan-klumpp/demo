test -e /media/b/6g/backup/4_backup_sync/4t || return 35
test -e /media/b/4t || return 32
brs /media/b/4t /media/b/6g/backup/4_backup_sync commit
