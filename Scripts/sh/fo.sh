parm=$(clipdef "$*")
findhead="$(f "$parm"|head -n 1)";
not isval $findhead && { err 'matching file not found'; return; }
o "$findhead"