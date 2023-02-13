fn=~/_$(btime)_audio.zip
7z a -tzip $fn "$@"
echo -n $fn|clip 
sett
