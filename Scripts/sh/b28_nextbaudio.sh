sqlite3 ${HOME}/l/15 "insert into baudio (i) select (max(i) + 1) from baudio" > /dev/null
sqlite3 ${HOME}/l/15 "select max(i) from baudio"
