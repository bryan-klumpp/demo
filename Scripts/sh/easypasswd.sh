#set -x
#test -e /dev/disk/by-uuid/70641c9a-bdb3-4361-8f55-1ffeb1d8dee7 && { cluks /dev/disk/by-uuid/70641c9a-bdb3-4361-8f55-1ffeb1d8dee7; }
{ cat $(b 4)/easy; cat $(b 4)/easy; } | sudo passwd b 
