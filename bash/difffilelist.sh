wdir="$(pwd)"
left=$(can "$1")
right=$(can "$2")
cd "$left"
find|sort > /tmp/left
cd "$right"
find|sort > /tmp/right
cd "$wdir"
diff /tmp/left /tmp/right
echo 'above: diff /tmp/left /tmp/right'
