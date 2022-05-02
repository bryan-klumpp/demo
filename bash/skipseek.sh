sd echo asdf || return  ##################### just get password out of the way

sout=$sin ################# for now assume it's a dangerous mistake to have different values for in and out offset
test -z $cfile && cfile=/tmp/"$RANDOM"_from_skipseek.sh
test -z $sin   && return 33
test -z $sout  && return 44
cfile="$cfile".crc32

echo 'variables are sin, sout, ifile, ofile, and cfile (checksum log):\n'"$sin"'\n'"$sout"'\n'"$ifile"'\n'"$ofile"'\n'"$cfile"'; sleeping for 20...'; sleep 20 || return

crc32 <(sd dd bs=MiB iflag=fullblock,skip_bytes if="$ifile" skip="$sin" | pv | tee >(sd dd conv=notrunc bs=MiB oflag=seek_bytes of="$ofile" seek="$sout") ) | tee -a "$cfile"

