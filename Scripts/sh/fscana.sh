isint $1 && { scanres=$1; shift 1; } || scanres=100
scannedfilename="./scanned_$(date +%Y%m%d%H%M%S)_"$*"_unknown_scanner_scanned.jpg"
tfile=/ram/$RANDOM$RANDOM.tif
sudo scanimage --mode Color > $tfile 
cat $tfile | convert - "$scannedfilename" && ls "$scannedfilename" 

