isint $1 && { resolution=$1; shift 1; } || resolution=100
sfn=''
for s; do { 
  [[ $s =~ [0-9]{8} ]] && { s='actual_date_transaction_'$s; }  
  test -z "$sfn" && sfn=$s || sfn=$sfn' '$s
}; done

sfn=$(underscore "$sfn")

test -z $(bset scanner) && { echo 'please setscan'; return; }

scannedflag=''; 
scannedfilename="./$(date +%Y%m%d%H%M%S)_${sfn}_$(underscore "$(bset scanner)")_scanned.jpg"
test -z $scannedflag && fscana "$sfn" && scannedflag=x

clip "$scannedfilename"
#o $sfn


#hpaio:/net/hp_officejet_pro_8610?ip=192.168.2.101&queue=false
