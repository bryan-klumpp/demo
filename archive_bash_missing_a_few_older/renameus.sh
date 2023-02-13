echo '' > /tmp/1.sh
f ' [^/]*$' | tros #| ebxargs 'renameus1 {}' >> /tmp/1.sh


#newname=$(echo -n {} | sed 's/ /_/g')
#echo /bin/mv --no-clobber '\''{}'\'' '\''"$newname"'\'' >> /tmp/1.sh 


