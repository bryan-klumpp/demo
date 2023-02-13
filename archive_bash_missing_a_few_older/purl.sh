grabdown
linkfile=$(btime)_url
{ paste; echo; } >> $linkfile
isval $1 && ts "$1"
cat $linkfile
