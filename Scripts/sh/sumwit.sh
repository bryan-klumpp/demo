sql "
 select startday, round(duration,1) from sumwit where startday like '2017%'; 
 select round(sum(duration),1) as billable2017 from sumwit
  where startday between '2017-01-01' and '2017-09-02 23:59:59';
 select round(sum(duration),1) as free2017 from sumwit 
  where startday between '2017-09-03' and '2017-12-31';
"
