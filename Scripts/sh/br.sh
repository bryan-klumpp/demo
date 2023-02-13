isval $(v scannerb) || { echo please set scannerb; return; }

scannedfilename="$(btime)_Brother_HL-2280_scanned_$(underscore "$*").jpg"
regex='(^|[^0-9])(100|150|200|300)([^0-9]|$)'
brres=$(echo -n "$*" | grep -Eo "$regex" | sed --regexp-extended 's/'"$regex"'/\2/')
isval $brres || brres=300

#note: options of 100 150 200 300
{ sudo scanimage --resolution $brres --format=tiff -d "$(bset scannerb)" --mode='24bit Color'
         echoe 'scanner return code: '$?; } |
         convert - "$scannedfilename" 2>/tmp/err.log
false && grep -E 'open of device brother4.* failed: Invalid argument' && {
  err 'scan failed; attempting to reset scanner variable'
  setscan
}   
#Brother machine does not like scanimage option --mode Color which works for Epson but it seems like the equal sign is preferred over space anyway.  Brother also forced me to use sudo otherwise it fails to even open scanner.
chown b "$scannedfilename"
viewimage "$scannedfilename"

return #------------------------------------------------------------------------------





  #--mode='24bit Color' for scanimage not sure why not working
#########WARNING stderr nulled due to noise # genesys:libusb:002:020 (numbers vary based on port) or pixma:04A9173A_B94E2B or v4l:/dev/video0 (epson) or old Epson epson2:libusb:001:016 or juse scanimage -L



#sudo scanimage -x 215.6801556 -y 355.3673032 --resolution $scanres --format=tiff -d "$(bset scannerb)" --mode='24bit Color' |convert - "$scannedfilename"    #Brother machine does not like scanimage option --mode Color which works for Epson but it seems like the equal sign is preferred over space anyway.  Brother also forced me to use sudo otherwise it fails to even open scanner.
 #  -x 0..215.9mm (in steps of 0.0999908) [215.88]
 #       Width of scan-area.
 #   -y 0..355.6mm (in steps of 0.0999908) [355.567]

