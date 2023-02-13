isval $1 && bword=$1
not isval $bword && bword=$(paste)
diatheke -b WebstersDict -k $bword;