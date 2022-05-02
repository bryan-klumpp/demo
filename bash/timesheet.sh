echo 'current time: ';date;sleep 2
te $(b 5959)
return


#parameters: 1=2017-02-16  2=8.8
if isval $1; then {
hours=$1; shift 1
bday=$(date +%Y-%m-%d)
if isval $1; then bday=$1; fi
sql 'update timesheet set hours='$hours' where bday = '\'$bday\'
#sql 'select * from timesheet where bday='\'$bday\'
timesheet #recursive but no parameter
} else { sql "select * from timesheet order by bday"; } fi
