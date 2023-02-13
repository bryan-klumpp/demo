ls|ebxargs 'test -f {} && exit 0; test -d {} && isval $(ls {} | grep xlsx) && exit 0; echo {}' 
