e "$@"
return

isint $1 && { resolution=$1; shift 1; } || resolution=100
sfn=''
for s; do { 
  [[ $s =~ [0-9]{8} ]] && { s='actual_date_transaction_'$s; }  
  test -z "$sfn" && sfn=$s || sfn=$sfn' '$s
}; done

sfn=$(underscore "$sfn")

#test -z $(bset scanner) && { echo 'please setscan'; return; }

#while [ $? -ne 0 ]; do {
scannedflag=''; 
scannedfilename="./$(date +%Y%m%d%H%M%S)_${sfn}_$(underscore "$(bset scanner)")_scanned.jpg"
test -z $scannedflag && fscanh 100 "$sfn" && scannedflag=x
#test -z $scannedflag && fscane jpg 300 "$sfn" && scannedflag=x
#test -z $scannedflag && ! test -z $(bset scannerb) && fscanb 200 "$scannedfilename" && scannedflag=x
#test -z $scannedflag && scanimage --resolution 100 --format=tiff -d "$(bset scanner)" | 
#     convert - "$scannedfilename" && scannedflag=x
[ $? -eq 0 ] && clip "$scannedfilename" && o $scannedfilename
#} done


#hpaio:/net/hp_officejet_pro_8610?ip=192.168.2.101&queue=false
#hpaio:/net/envy_5540_series?ip=192.168.0.50&queue=false
