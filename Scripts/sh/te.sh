#which leafpad || { echo 'installing leafpad...'; inst leafpad || return 35; }
file="$*"
testf "$file" || file=$(echon "$file"|tr ' ' '_').txt
#testf "$file" || file=$(paste)
#testf "$file" || { file="$(bdate)_$file"; }
#nano  --syntax=none  "$file"  #--mouse
#a leafpad "$file"
a kate "$file"
