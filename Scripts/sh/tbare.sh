#echo 'whatisgoingonhere'
#sqlite3 /b/l/15 "select desc from do_log where end = 'in_progress'"; 
sql1 "select desc from do_log where start = (select max(start) from do_log where start < current_timestamp);" 
return



bcat=$(sql1 "select desc from do_log where start = (select max(start) from do_log where start < 'now' )")
test -z "$bcat" && { 
  tbaredump=/b/log/$(bdate)_tbare_zero_length_dump.txt
  err 'ERROR blank tbare; dump sent to '$tbaredump
  sql "select * from do_log" > $tbaredump
}
echo -n "$bcat"
