#ran on whole library 2017-07-28
f|grep -iE '\.mp3$' | sed --regexp-extended 's/\.[Mm][Pp]3$//'|bxargs 'test -e {}.wav && /bin/mv -v {}.mp3 {}.wav.mp3'
