#padsp brec -s 8000 -b 8 -B 8000000 /l/80/$(btime)_lifelog.8khz.8bit.littleendian.raw_audio
arecord --format=S16_LE --rate=44100 --nonblock /l/80/$(btime)_lifelog_S16_LE_44100.wav 
