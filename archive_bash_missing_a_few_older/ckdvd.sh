isval $1 || { echo 'usage: tsize=12345; ckdvd /isofile.iso ' ; return 33; }

function catw256() {  #not working - thought I would be smart and do sha256sum in one shot
  cat "$1" | tee >(sha256sum - 2>&1 > /tmp/ckdvdsha256sum)
}

{
isofile="$1"
tsize=$(stat "$isofile" --printf='%s')
########################tmpfile=for_comparison_deleteme.iso
########################! test -e "$tmpfile" && sd cat /dev/dvd | ddcb $tsize > "$tmpfile"
echo $(btimes) starting diff...
########################diff "$isofile" "$tmpfile" && echo 'same!' && rm $tmpfile
########################cat /tmp/ckdvdsha256sum
echo -n 'loc: ' ; 
   sha256loc=$(cat "$isofile" | sha256sum - | grep -P '\S'); echo $sha256loc
echo -n 'dvd: ' ; sd cat /dev/dvd | ddcb $tsize | sha256sum - | gh $sha256loc
} 2>&1 | tee /tmp/ckdvd.log
