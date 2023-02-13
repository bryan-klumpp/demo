#seems to be buggy - TODO fix
p="$*"
test -f "$p" && { echo "$p"; return; }  #test exact match?
f=$(ls -d *"$p"*|filesonly|sort|h1);    #set shell glob 
test -f "$f" && { echo "$f"; return; }  #test shell globbing
