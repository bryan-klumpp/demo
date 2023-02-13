#grep coloring unused for now, not really needed and can't figure out how to exclude surrounding markers

{ sql "select dat,tim, round(remain,1), i, desc from task where remain > 0 order by dat desc,tim desc" | 
 grep --color=auto '|[0-9]*|' | sed 's/|/__/g'; } | {
 isval $1 && { g "$*"; } || cat -
}  






#sql1 "select 'next i: '||(max(i) + 1) from task"; sql1 ".schema task"|grep -i 'create table';
