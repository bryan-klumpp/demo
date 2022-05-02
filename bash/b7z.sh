q="'"
sample1='sudo 7z a -si -tzip -mem=AES256 -ppassword $(btime)_archive.bzip  #-mm=Copy -mx=0'
sample2='sudo 7z a -p$(cat $(b 4)/20171010_*) archive.7z *'
sample3='allmine && fr|grep -E '$q'\.(png|jpg)$'$q'>/tmp/fl && 7z a -i@/tmp/fl $(btime)_archive.7z'
echo "$sample3"|clip
echo "$sample1"
echo "\n$sample2"
echo 'a firefox file:///usr/share/doc/p7zip-full/DOCS/MANUAL/switches/method.htm#ZipX'

