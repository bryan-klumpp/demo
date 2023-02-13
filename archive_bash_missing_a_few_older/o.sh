isint "$1" && { o "$(b "$1")"; return; }
 
file=$(clipdef "$*")
test -f "$file" || { file=$(echo -n *"$file"*); }
#echo '$file after trying shell globbing: '"$file"
test -f "$file" || { file=$(ls --sort=time | head -n 1); }
co "$file" '.txt$' && { a kate "$file"; return; }
co "$file" '.ogg$' && { a vlc "$file"; return; }
co "$file" '.jpg$' && { a eog "$file"; return; }
$(j getapp "$file") "$file" &>/dev/null &disown  #j getapp reads /l/2004081218
