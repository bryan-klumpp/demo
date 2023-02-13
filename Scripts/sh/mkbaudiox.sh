arg="$1"
qq='"';
q="'"
#nextbaudioi=$(. /b/l/28)
#echo -n $nextbaudioi | grep -E '.' || exit 111;
{
  echo -n '/bin/mv --no-clobber --verbose '; 
  echo -n "$arg" | sed -E --null-data 's/./\\\0/g';  #same as esc.sh 
  echo -n ' '  
  echo -n "$arg" | 
#why the first slash       sed --regexp-extended 's#/([^/]*)\.(wav)$#/\1_baud'$(. /b/l/28)'_.\2#I' |      #28=nextbaudio.sh
       sed --regexp-extended 's#(.*)\.(wav)$#\1_baud'$(. /b/l/28)'_.\2#I' |      #28=nextbaudio.sh
         sed -E --null-data 's/./\\\0/g' #same as esc.sh
  echo ' || return 111'
}

