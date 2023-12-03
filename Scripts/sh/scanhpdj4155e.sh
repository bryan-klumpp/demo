isint $1 && { scanres=$1; shift 1; } || scanres=150
scannedfilename="./$(date +%Y%m%d%H%M%S)_"$*"_scanned.tiff"
scanimage --resolution $scanres -d 'escl:http://localhost:60000' --format=tiff --mode Color > "$scannedfilename" && ls "$scannedfilename" 

return

scanimage --resolution $scanres -d 'escl:http://localhost:60000' --format=tiff --mode Color  |
  convert - "$scannedfilename" && ls "$scannedfilename" 

#device `hpaio:/usb/ENVY_5540_series?serial=TH6BI2R1S30671' is a Hewlett-Packard ENVY_5540_series all-in-one
#hpaio:/net/envy_5540_series?ip=192.168.0.50&queue=false
#scanimage --jpeg-quality 5 --resolution $scanres --format=tiff --mode Color  |

#device `escl:http://localhost:60000' is a HP DeskJet 4100 series [BF257A] (USB) platen,adf scanner
#device `airscan:e0:HP DeskJet 4100 series [BF257A] (USB)' is a eSCL HP DeskJet 4100 series [BF257A] (USB) ip=127.0.0.1
#device `hpaio:/usb/DeskJet_4100_series?serial=CN26QFF0ZF' is a Hewlett-Packard DeskJet_4100_series all-in-one

