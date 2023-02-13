for i; do {
  markeddone=$(sql1 "select desc from task where i = $i") || return 33
  isval $markeddone && sql "update task set remain = 0 where i = "$i &&
     echo '\nmarked done: '$(highlight "$markeddone") || return 83
} done
