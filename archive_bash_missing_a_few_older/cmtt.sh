#fancy bash subinvocation but somehow it seems to mostly work except its not printing the commentary book name #xargs -t echoes commands
verseref="$*"; not isval $verseref && verseref=$(paste)
cat "$(b 7)" | xargs -i bash -c "echo -n '<<<'"{}"'>>>' && diatheke -b "{}" -k $verseref" \
   | grep -vE '^[(:]|No Commentary on these verses is yet included' > /tmp/cmt
cat /tmp/cmt | less -R; 

#   | sed --regexp-extended 's/\x20//g'  #attempt to remove weird character
