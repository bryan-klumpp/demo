scannedfilename="./$(date +%Y%m%d%H%M%S)_"$*_Epson_WF-3640_scanned.jpg
scanimage --resolution 300 --format=tiff -d epkowa:usb:001:008 --mode Color \
   | convert - "$scannedfilename" && ls "$scannedfilename" 
echo -n $scannedfilename | clip
/usr/bin/display-im6.q16 -nostdin "$scannedfilename"




#WARNING stderr nulled due to noise # genesys:libusb:002:020 (numbers vary based on port) or pixma:04A9173A_B94E2B or v4l:/dev/video0 (epson) or old Epson epson2:libusb:001:016 or juse scanimage -L
