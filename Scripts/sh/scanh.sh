test -z $scannerh && scannerh=$(scanimage -L | grep -oE 'hpaio.*1S30671' | head -n 1)
isint $1 && { scanres=$1; shift 1; } || scanres=150
scannedfilename="./$(date +%Y%m%d%H%M%S)_"$*"_HP_ENVY_5540_scanned.jpg"
scanimage --resolution $scanres --format=tiff -d $scannerh --mode Color  |
  convert - "$scannedfilename" && ls "$scannedfilename" | tee >(clip) 
viewimage "$(paste)"

#device `hpaio:/usb/ENVY_5540_series?serial=TH6BI2R1S30671' is a Hewlett-Packard ENVY_5540_series all-in-one
