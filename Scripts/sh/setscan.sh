L=$(scanimage -L)
scannere=$(echo "$L" | grep -o 'epkowa.\{12\}')
scannerb=$(echo "$L" | grep -oE 'brother4:bus[0-9]*;dev[0-9]*')
scannerh=$(echo "$L" | grep -oE 'hpaio.*1S30671')
bdeclare scannere "$scannere"
bdeclare scannerb "$scannerb"
bdeclare scannerh "$scannerh"
test -z $scannerh || { bvar scanner "$scannerh"; return; }
test -z $scannere || { bvar scanner "$scannere"; return; }
test -z $scannerb || { bvar scanner "$scannerb"; return; }
test -z $scannern || { bvar scanner "$scannern"; return; }

#device `hpaio:/usb/ENVY_5540_series?serial=TH6BI2R1S30671' is a Hewlett-Packard ENVY_5540_series all-in-one
