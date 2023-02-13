dir=$1
isempty $dir && dir=.
baobab "$dir" & disown
