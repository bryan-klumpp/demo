sql "select round(sum(effort) * 24 * 60,1)||' minutes of prayer' from v_do_log "\
"where (desc like '%pray%') and start like '$(bdates)%'" | nosql
