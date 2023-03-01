#xargs detail block
co "$1" '^x$' && {
  echo 'debug - using xargs detail block'
  test -L {}   && { echo 'ERROR - trying to make symlink from symlink'      ; exit 20; return 20; }
  ! co {} '^/' && { echo 'ERROR - trying to make symlink from relative path'; exit 22; return 22; }
  shift 1; val="$*" 
  num=$(echo "$val" | sed --regexp-extended "s@.*/b([0-9]*)_[^/]*/?\$@\1@g");
  isval "$val" && test -L /l/$num && { echo "duplicate bln: "$num; rm /l/$num; }
  ln -s {} /l/$num || echo "something bad happened: $num "{};
  return
}

ddir="$1"
isval "$ddir" || ddir="$(pwd)"
find $(can "$ddir") | grep -vE 'backup|copy\W|archive|RecentDocuments|wav_masters' |
   grep -E '/b[0-9]*_[^/]*/?$' | tee -a /tmp/debugbln.log |
   sed --null-data 's/\r\|\n/\x00/g' |
   sed -E --null-data 's/./\\\0/g' |
   xargs -i -r --null bash --rcfile /tmp/dummyrc -r -c \
       ' { val={}; num=$(echo {} | sed --regexp-extended "s@.*/b([0-9]*)_[^/]*/?\$@\1@g"); 
           test -L /l/$num && { echo "duplicate bln: "$num; rm /l/$num; }
           ln -s {} /l/$num || echo "something bad happened: $num "{}; } ' 




