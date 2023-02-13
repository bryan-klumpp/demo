echo 'should highlight matched sha256sum'

### with temp file
#tmpiso=/tmp/dvd.iso; tmpsum=/tmp/sha256sum_dvd.iso
#cat $tmpiso | sha256sum > $tmpsum
#cat $tmpsum | g "$2" && echo ' match!' || { echo 'no match, see '$tmpiso' and '$tmpsum; cat $tmpsum; }

dd status=progress iflag=count_bytes,fullblock count=$1 bs=MiB | sha256sum | g "$2" && echo ' match!' || { echo 'no match'; }
