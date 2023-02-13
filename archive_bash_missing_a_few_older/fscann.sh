echo 'hpaio:/net/hp_officejet_pro_8610?ip=192.168.2.101&queue=false' > /ram/scanner ; return

scanres=$1;shift 1
scannedfilename="./$(date +%Y%m%d%H%M%S)_"$*"_HP_ENVY_5540_scanned.jpg"
scanimage  --mode=Color --format=tiff -d 'hpaio:/net/hp_officejet_pro_8610?ip=192.168.2.101&queue=false'  |
  convert - "$scannedfilename" && ls "$scannedfilename" 

#device `hpaio:/usb/ENVY_5540_series?serial=TH6BI2R1S30671' is a Hewlett-Packard ENVY_5540_series all-in-one
#hpaio:/net/hp_officejet_pro_8610?ip=192.168.2.101&queue=false
