#sed --null-data "s/'/\\\'/g" | sed --null-data 's/"/\\\"/g' | sed --null-data 's/\$/\\\$/g'
#sed -E --null-data 's/( |'\"'|\$)/\\\0/g'
test -z "$1" || { echo -n "$1" | . /sh/esc.sh; exit; } #recursive but without argument
sed -E --null-data 's/./\\\0/g'
