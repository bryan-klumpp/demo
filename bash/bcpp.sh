echo "bcp no longer invokes safe files only automatically; please consider piping through safe; pausing 4 sec"; { sleep 4 || return 39; }

echo '' > /t/err; {

[ $# -eq 0 ] && { echo 'usage: stream relative file list (using f or something similar) to: bcp /dest_parent_folder ; #will skip nocopy and Moth[1-9]'; return; }
[ $# -ge 2 ] && { echo 'only parameter should be destination parent directory'; return 142; }

dstpar="$1"
test -d "$dstpar" || { echo 'destination parent does not exist; please create'; return 88; }

#note cp -d takes care of symbolic links by copying only reference
bxargs '{ sudo test -f {} || exit 0; 
       cp -d --preserve=all --parents --no-clobber --verbose --update {} '"$dstpar"' ||   #try first without sudo.  
  sudo cp -d --preserve=all --parents --no-clobber --verbose --update {} '"$dstpar"';   #note we are not masking errors from bxargs
} '
retcodxar=$?
echo "attempting rsync to see if we're missing anything"
sudo rsync --existing -a --verbose --dry-run --delete-before "$(pwd)/*" "$dstpar" &&
echo 'to verify - see above, you should not have seen any files output from rsync'
manualrsync="sudo rsync --existing -a --verbose \"$(pwd)/*\" \"$dstpar\" --delete-before --dry-run"
echo -n "$manualrsync" | clip
echo 'clipped manual: prompt> '"$manualrsync"
} #echo 'to see all errors, do cat /t/err'
echo return code from bxargs cp was $retcodxar
 
