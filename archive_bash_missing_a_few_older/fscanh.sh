isint $1 && { scanres=$1; shift 1; } || scanres=100
scannedfilename="./scanned_$(date +%Y%m%d%H%M%S)_"$*"_HP_ENVY_5540_scanned.jpg"
scanimage --resolution $scanres --format=tiff --mode Color  |
  convert - "$scannedfilename" && ls "$scannedfilename" 

#device `hpaio:/usb/ENVY_5540_series?serial=TH6BI2R1S30671' is a Hewlett-Packard ENVY_5540_series all-in-one
#hpaio:/net/envy_5540_series?ip=192.168.0.50&queue=false
#scanimage --jpeg-quality 5 --resolution $scanres --format=tiff --mode Color  |
