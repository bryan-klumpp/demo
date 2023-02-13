
#imagescan --no-interface --help | l
#imagescan --no-interface --image-format JPG --resolution 300 --doc-source "Document Table" --image-count 1 --jpeg-quality 90 --transfer-format RAW > $scannedfilename
# --doc-source "Document Table"  and   transfer-format RAW seem to cause positional options error

res=300
isint $1 && { res=$1; shift 1; }
scannedfilename="$(date +%Y%m%d%H%M%S)_scanned_"$(tofilename "$*")"_ET-4750_scanned.jpg"
{ imagescan --no-interface --image-format JPEG --resolution $res --jpeg-quality 90 > "$scannedfilename"; o "$scannedfilename"; } & disown
