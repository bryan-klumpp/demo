function bln1guts() {

ddir="$*"  #note: can be a file as well, as in following one-liner return case
test -z "$1" &&  ddir="$(pwd)"
test -f "$ddir" && { /sh/bln1gutsexit.sh "$ddir";return; }
isval "$ddir" || ddir="$(pwd)"
find $(can "$ddir") | mast |
#   grep -E '^/media/b' | #to deal with bizarre behavior see blnbad.sh actually was endline in folder name
   grep -E '/b[0-9]{1,}_[^/]*/?$' | tee /tmp/debugbln.log |
   sed --null-data 's/\r\|\n/\x00/g'                      | #convert endlines to null
   sed -E --null-data 's/./\\\0/g'                        | #escape everything
#   xargs -i -r --null bash --rcfile /tmp/dummyrc -r -c '/sh/bln1gutsexit.sh '{}
   xargs -i -r --null bash --rcfile /tmp/dummyrc -c '/sh/bln1gutsexit.sh '{}

}

test -e /l || { sudo mkdir /l; sudo chown b /l; }
logfile=/tmp/bln1.log
echo 'bln1guts '"$@"' 2>&1 >> '$logfile >> $logfile
bln1guts "$@" 2>&1 >> $logfile
