sql "select startday, round(duration,1) from sumw where startday > '2018-04-20'; 
select substr(startday,1,7) as month, round(sum(duration),1) from sumw where startday > '2017-09-27' group by month"
