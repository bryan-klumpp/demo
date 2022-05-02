cl; subcat=''
isval $1 || { echo "FYI: usage> pray [maximum type pause in whole minutes] [subcategory]"; return; }

isint $1 && { intvl=$1; shift 1; } || intvl=.8   #type delay parameter
isval $1 && { subcat=":$1"; shift 1; }           #subcat parameter
pt 1
{
timetrack pray$subcat j alarm $intvl; jnl /tmp/javaprayer.txt 
#timetrack pray$subcat audjnl pray:"$*"

 
 #timetrack pray$subcat te $(b 25)
 pt 1
# t t; 
 echo "Don't forget to change time category"
} &
o $(b 25)  #praylist
