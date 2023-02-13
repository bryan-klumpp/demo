echo 'rename - this is risky'; return 33

test -z "$1" && { echo 'usage: "source directory shortname" "full path of dest parent dir"'; return 82; }
ssrc="$1"
dstp="$2"
dst="$2"/"$1"

#echo 'starting cp...'
#sd cp -av --no-clobber "$ssrc" "$dstp"  #-l to make hard links seems risky since I dont understand the warning about cross-device links
echo 'starting rsync...'
#not using --hard-links see note about -l and cross-device links in cp above
sd rsync -av --links --no-inc-recursive --update "$ssrc" "$dstp" || { echo 'if rsync fails, try chown -R b '"ssrc"; return 124; }
echo 'starting chown...'
sd chown -R b "$dst"
sd -K

echo 'starting compare...' #basically duplicating bdiff.sh here
echo asdf1 >  "$ssrc"/deleteme_tf1.txt
echo asdf2 > "$dst"/deleteme_tf1.txt
echo asdf3 >  "$ssrc"/deleteme_oil.txt 
difffile=/tmp/$(btime)_bdiff
diff --no-dereference --brief --recursive --binary "$ssrc" "$dst" 2>&1 | 
    grep -v 'is a fifo' | tee "$difffile"
echo 'see '$difffile
rm "$ssrc"/deleteme* "$dst"/deleteme*

echo 'if it took a while and now you only see the artificial differences logged, then copy and compare was successful'
