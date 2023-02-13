test -z "$1" && { echo "usage: /prompt$ rchive \"onestringdescription\" roots..."; return 83; }

test -d $(b 22)/archive || mkdir $(b 22)/archive
adir=$(b 22)/archive/$(btime)_"$1"
mkdir "$adir" && shift 1
cp -a "$@" "$adir"
ls -al "$adir"
echo "archived to (directory listing above): "$adir
#clip "$adir"
