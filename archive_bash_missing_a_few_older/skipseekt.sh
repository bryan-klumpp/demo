
test -z $cfile && cfile=/tmp/$RANDOM_from_skipseek.sh.crc32
test -z $sin   &&   sin=0
test -z $sout  &&  sout=$sin

echo 'variables are sin, sout, ifile, ofile, and cfile (checksum log):'"$sin"';'"$sout"';'"$ifile"';'"$ofile"';'"$cfile"'; sleeping for 5...'; sleep 5 || return

dd iflag=skip_bytes if="$ifile" skip="$sin" oflag=notrunc,seek_bytes of="$ofile" seek="$sout"

sin=''; sout=''; ifile=''; ofile=''; cfile=''