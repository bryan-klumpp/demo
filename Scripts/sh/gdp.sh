sql "insert into gdp values ( (select max(i) + 1 from gdp), $1, $2, $3, null )"
echo 'gdp columns: i, pile, len1, len2, pos'
