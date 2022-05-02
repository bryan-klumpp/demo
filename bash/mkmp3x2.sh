wavfile="$1"

#mp3file="$(echo "$wavfile" | sed --regexp-extended 's#\.wav$#\.mp3#')"  
#the above was before I went to simply tacking .mp3 on the end of .wav (below)

mp3file="$wavfile".mp3
mp3fileesc="$(echo -n "$mp3file" | sed -E 's/./\\\0/g')"
test -e "$mp3file" || { echo -n 'test -f '"$mp3fileesc"' || lame '; echo -n "$wavfile" | sed -E 's/./\\\0/g'; \
            echo ' '"$mp3fileesc"tmp' && mv '"$mp3fileesc"tmp' '"$mp3fileesc"; } 


