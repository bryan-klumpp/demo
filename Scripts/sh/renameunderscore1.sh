#set +x
co "$1" ' ' && /bin/mv --no-clobber "$1" $(echo -n "$1" | sed --regexp-extended "s/ /_/g")
#true 



#ls | ebxargs 'rename "s/ /_/g" {} ; isdir {} && { cd {} && renameunderscore; } ' 


#tros | bxargs 'rename "s/ /_/g" {}'
