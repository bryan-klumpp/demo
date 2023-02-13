ffmpeg -f concat -safe 0 -i \
  <(for f in $(ls *.wav | sort | grep -vE '01|02'); do echo "file '$PWD/$f'"; done) -c copy concat.wav
