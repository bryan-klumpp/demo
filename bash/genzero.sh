function gzf() {  
  dd if=/dev/zero bs=1M iflag=count_bytes count=$1 > $ih.z
}

ii=512;
ih=1
retcod=0
while [ $retcod -eq 0 ] ; do {
  gzf $ii
  ii=$(( $ii * 2 ))
  ih=$(( $ih + 1 ))
  retcod=$?
} done 
