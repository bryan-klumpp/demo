#note the exit 0 is so we dont kill bxargs on the first no-op with missing mp3

echo HELLOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOO
cd /mnt/64gsd && f | grep -iE 'baud[0-9]*_.*wav$' | 
  bxargs 'echo {}; test -f {}.mp3 || exit 0;  #experimental comment - exit 0 to avoid killing bxargs on first missing mp3 file  
   cp -av --parents {} /mnt/5tb/Backup5_wav_masters_with_compressed_equivalents && rm {}'
