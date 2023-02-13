mount | grep -E '/b/kt' || { sd mount "$(getkan)"-part1 /b/kt || return 22; }
mount | grep -E '/b/kt' || { echo 'failure to mount /b/kt'; return 23; }
