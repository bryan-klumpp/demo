#sed --null-data "s/'/\\\'/g" | sed --null-data 's/"/\\\"/g' | sed --null-data 's/\$/\\\$/g'
#sed -E --null-data 's/( |'\"'|\$)/\\\0/g'
test -z "$1" || { echo -n "$1" | esc; return; } #recursive but without argument
sed -E --null-data 's/[^A-Za-z0-9_]{1}/\\\0/g'
