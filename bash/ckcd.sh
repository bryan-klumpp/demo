isofile="$1"
tsize=$(stat "$isofile" --printf='%s')
tmpfile=for_comparison_deleteme.iso
! test -e $tmpfile && sd cat /dev/cdrom | ddcb $tsize > $tmpfile
echo starting diff...
diff "$isofile" $tmpfile && 'same!' && rm $tmpfile