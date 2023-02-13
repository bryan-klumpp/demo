mvb "$@"




return #########################
[ $# -eq 2 ] || { err 'illegal number of arguments to m.sh'; return 111; }
wd=$(pwd)
co "$wd" 5tb && { /bin/mv --no-clobber "$@"; return; }

echo 'the rest of this script is out of date'; return 2;

test -d /mnt/bext"$wd" || { err 'replication directory not available'; return 111; }
co "$wd" '^/b' && not co "$wd" bcopy && {
  /bin/mv --no-clobber "$1" "$2"
  cd /mnt/bext"$wd" && /bin/mv --no-clobber "$1" "$2"
  cd "$wd";
  return;
}
err 'not in legal directory for assisted and replicated moves'; return 111;
