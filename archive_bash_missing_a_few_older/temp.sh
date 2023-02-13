isval $1 && echo $1 > /home/b/temperature
#redshift -PO $(cat /home/b/temperature)
redshift -O $(cat /home/b/temperature)
