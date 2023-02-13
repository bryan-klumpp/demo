
val="$*"
test -L "$val"   && { echo 'ERROR - trying to make symlink from symlink'      ; exit 20; }
echo -n "$val" | grep --silent -E '^/' || { echo 'ERROR - trying to make symlink from relative path'; exit 22; }
num=$(echo "$val" | sed --regexp-extended 's@.*/b([0-9]*)_[^/]*/?$@\1@g');
###########! test -z "$val" && test -L /l/$num && { echo "duplicate bln: "$num; rm /l/$num; }
abs=$(readlink -e "$val")
test -e "$abs" || { echo 'does not exist after readlink: '$val; exit 92; }           
  test -L /l/$num && rm /l/$num
! test -L /l/$num && ln -s "$abs" /l/$num || echo "dumb idiot $num "{};


