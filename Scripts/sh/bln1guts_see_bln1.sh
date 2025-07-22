ddir="$1"  #note: can be a file as well, as in following one-liner return case
test -f "$ddir" && { $(shpath)/bln1gutsexit.sh "$ddir";return; }
isval "$ddir" || ddir="$(pwd)"
find $(can "$ddir") | grep -vE 'backup|copy\W|archive|RecentDocuments|wav_masters' |
   grep -E '/b[0-9]*_[^/]*/?$' | tee -a /tmp/debugbln.log |
   sed --null-data 's/\r\|\n/\x00/g' |
   sed -E --null-data 's/./\\\0/g' |
#   xargs -i -r --null bash --rcfile /tmp/dummyrc -r -c '$(shpath)/bln1gutsexit.sh '{}
   xargs -i -r --null bash --rcfile /tmp/dummyrc -c '$(shpath)/bln1gutsexit.sh '{}
