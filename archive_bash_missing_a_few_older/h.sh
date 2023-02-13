#isint $1 && { scanres=$1; shift 1; } || scanres=100
regex='(^|[ _])(75|100|200|300|600|1200)([ _]|$)'
hres=$(echo -n "$*" | grep -Eo "$regex" | sed --regexp-extended 's/'"$regex"'/\2/')
isval $hres || hres=300

scannedfilename="$(date +%Y%m%d%H%M%S)_scanned_"$(tofilename "$*")"_HP_ENVY_5540_scanned.jpg"
echo beginning to scan "$(pwd)/$scannedfilename"

#alternate method maybe for network scanning - JPEG quality control does not seem to work though, see hscanset command
#scanimage -d 'hpaio:/usb/ENVY_5540_series?serial=TH6BI2R1S30671' \
#   --resolution $hres --format=jpeg --mode Color --compression JPEG 1>"$scannedfilename"  2>/tmp/h.sh.stderr

scanimage -d 'hpaio:/usb/ENVY_5540_series?serial=TH6BI2R1S30671' \
   --resolution $hres --format=tiff --mode Color 1> /tmp/rawscan.tif 2>/tmp/h.sh.stderr
[ $? -eq 0 ] && convert /tmp/rawscan.tif "$scannedfilename"

viewimage "$scannedfilename" 
cat /tmp/h.sh.stderr

###############################################
#device `hpaio:/usb/ENVY_5540_series?serial=TH6BI2R1S30671' is a Hewlett-Packard ENVY_5540_series all-in-one
#hpaio:/net/envy_5540_series?ip=192.168.0.50&queue=false
#scanimage --jpeg-quality 5 --resolution $scanres --format=tiff --mode Color  |
#hpaio:/net/envy_5540_series?ip=192.168.0.55&queue=false
