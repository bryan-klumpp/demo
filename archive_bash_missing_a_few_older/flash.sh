
i=0;
h=0;
s=''
b=''
while (( $h < $LINES )) ; do {
  while (( $i < $COLUMNS )) ; do {
    s=${s}X
    b="$b"$'\b'
    i=$(($i + 1))
  }; done
  if false; then { s=$s"\n"; b="$b"$'\b'; }; fi
  h=$(($h + 1)); i=0
}; done
echo $s
while false; do {
  echo -n "$s"
  sleep 1
  echo -n "$b"
  sleep 1
}; done
echo $COLUMNS X $LINES =  
#COLUMNS
#LINES

