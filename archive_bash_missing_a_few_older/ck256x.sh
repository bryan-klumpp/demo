echo 'should highlight matched sha256sum'

### with temp file
#tmpiso=/tmp/dvd.iso; tmpsum=/tmp/sha256sum_dvd.iso
#cat $tmpiso | sha256sum > $tmpsum
#cat $tmpsum | g "$2" && echo ' match!' || { echo 'no match, see '$tmpiso' and '$tmpsum; cat $tmpsum; }


#ck256 2193522688 f295570badb09a606d97ddfc3421d7bf210b4a81c07ba81e9c040eda6ddea6a0

dd status=progress iflag=count_bytes,fullblock count=2193522688 bs=MiB | sha256sum | g "f295570badb09a606d97ddfc3421d7bf210b4a81c07ba81e9c040eda6ddea6a0" && echo ' match!' || { echo 'no match'; }
