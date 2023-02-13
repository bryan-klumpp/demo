weeksfromstart=$(sql1 "select ( julianday('$(btimes)') - julianday('2017-03-04')  ) / 7.0 from onerow")
hoursworked=$(sql1 "select sum(duration) * 24.0 from v_do_log where desc like '%work%' and start >= '2017-03-04'") 
targethours=$(math "$weeksfromstart * 25.0")
extraweeks=$(math "round ( ($hoursworked - $targethours) / (25.0), 2)" )
echo extra weeks: $extraweeks 


sql "select sum(duration) * 24.0 / (select ( julianday('$(btimes)') - julianday('2017-03-04')  ) / 7.0 from onerow) 
  from v_do_log where desc like '%work%' and start >= '2017-03-04'"

