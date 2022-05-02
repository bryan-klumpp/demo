[ $# -eq 0 ] && { echo "usage example: prompt> audjnl pray about Iowa"; return; }
tmpaudjnlfile=/t/t.ogg
ajdesc="$(underscore "$*")_audio_journal_fmts_wav_and_ogg_audjnl"
ajdfn=$(btime)_"$ajdesc".ogg
ajdfnw=$(btime)_"$ajdesc".wav

parecord --format=s16le --channels=1 --rate=44100 --file-format=wav > /tmp/audjnl.wav
oggenc -o "$ajdfn" /tmp/audjnl.wav
mv /tmp/audjnl.wav "$ajdfnw"
jnl "see audio journal audjnl file and parallel .wav: $ajdfn"
cvlc --play-and-exit $ajdfn



return
----extra
#snd; ####echo 'allowing 2 seconds for microphone settings'; sleep 2  #allow time to adjust microphone settings
tcb=$(tbare)
#parecord --format=s16le --channels=1 --rate=44100 --raw  > /tmp/audjnl.pcm.raw
#        cat /tmp/audjnl.pcm.raw | oggenc --raw --raw-bits-bits=16 --raw-chan=1 --raw-rate=44100 --raw-endianness 0 \
#            -C 1 -o "$ajdfn" -
#t jnl:audio"#$ajdesc" 
#barecord -t raw > /tmp/audjnl.pcm.raw
