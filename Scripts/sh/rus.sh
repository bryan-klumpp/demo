echo '' > /tmp/1.sh
f ' [^/]*$' | tros | ebxargs 'rus1 {}' >> /tmp/rus.sh
clip '/tmp/rus.sh'


#newname=$(echo -n {} | sed 's/ /_/g')
#echo /bin/mv --no-clobber '\''{}'\'' '\''"$newname"'\'' >> /tmp/1.sh 


