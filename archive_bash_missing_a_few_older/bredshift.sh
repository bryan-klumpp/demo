#redshift [-l LAT:LON | -l PROVIDER:OPTIONS] [-t DAY:NIGHT] [OPTIONS...]
#
num=2700
isval $1 && num=$1
redshift -O 1000
#proc "redshift" > /dev/null || redshift -l 40.8559819:-89.6801365 -t $num:$num & disown  
#5500 and 3000 probably best
