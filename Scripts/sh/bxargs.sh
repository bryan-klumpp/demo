echo '' > /tmp/blank
nocolor | sed --null-data 's/\r\|\n/\x00/g' |  #make endlines into zeros, if not already done
sed -E --null-data 's/./\\\0/g' |    #escape every single character

#note that we exit with 255 if there is ANY problem to terminate the whole xargs interaction
if true; then 
  nocolor | xargs -i -r -0 bash --rcfile /tmp/blank -c ' { '"$*"'; retcode=$?; [ $retcode -ne 0 ] && { echo exit code was $retcode; exit 255; }; } '; else    
  echo somethingelse; fi    

#xargs --interactive  


#xargs --verbose
