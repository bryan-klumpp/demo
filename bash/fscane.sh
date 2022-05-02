#WARNING stderr nulled due to noise # genesys:libusb:002:020 (numbers vary based on port) or pixma:04A9173A_B94E2B or v4l:/dev/video0 (epson) or old Epson epson2:libusb:001:016 or juse scanimage -L
scanext=$1;scanres=$2;shift 2
scannedfilename="./$(date +%Y%m%d%H%M%S)_"$*"_Epson_WF-3640_scanned.$scanext"
scanimage --resolution $scanres --format=tiff -d $scannere --mode Color  |convert - "$scannedfilename" && ls "$scannedfilename" # --mode Color