ls | ebxargs 'test -L {} && exit 0; test -d {} && exit 0; test -f {} && renameunderscore1 {}; true'











return ###########WHY IS THIS SO HARD?  JUNK BELOW APPARENTLY


#only does current directory; need to fix to do more
#recursive
echo do dirs
ls | directories | tee directories_output_debug.txt      | ebxargs 'echo dir {}; cd {} && renameunderscore && cd .. && renameunderscore1 {}' 
echo do files
ls | files       | tee files_output_debug.txt | grep ' ' | 
 ebxargs 'renameunderscore1 {}' 



#ls | ebxargs 'rename "s/ /_/g" {} ; isdir {} && { cd {} && renameunderscore; } ' 


#tros | bxargs 'rename "s/ /_/g" {}'
