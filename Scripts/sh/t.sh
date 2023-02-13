[ $# -eq 0 ] && { 
  talist | grep -E '2023-02' #| tail -n 25
  echo; echo -n 'usage: [all parms optional]  $ ta 41 '\''appointment for right now'\'' '
  echo -n $(echo -n $(bdate) | sed --regexp-extended 's/([0-9]{2})([0-9]{6})/\2/') | grep -z --color=auto '.*'
  echo ' '$(shorttimes)' 2.5'
  return
} 

i=''; desc=''; dat=''; tim=''; remain=''; isnewtask=''

for arg; do {
  is "$arg" '[0-9]{1,5}'            && { i=$arg; continue; }
  is "$arg" 'tod'                         && { dat=$(date --date "today"     '+%Y-%m-%d');  continue; }
  is "$arg" 'sun|mon|tue|wed|thu|fri|sat' && { dat=$(date --date "next $arg" '+%Y-%m-%d');  continue; }
  is "$arg" '[0-9]*\.[0-9]*'       && { remain=$arg;  continue; }
  is "$arg" '[0-9]{6}'             && { 
   dat=20$(echon "$arg"|sed -E 's/([0-9]{2})([0-9]{2})([0-9]{2})/\1-\2-\3/'); 
   echo set dat to $dat
   continue; 
  }
  co "$arg"      '^[0-9]:[0-9]{2}$'  && { tim=0$arg;   continue; }
  co "$arg" '^[0-9][0-9]:[0-9]{2}$'  && {  tim=$arg;   continue; }
  { desc="$arg"; continue; }
}; done

! isval $i && { isnewtask=true; { i=$(sql1 "select max(i) + 1 from task") || return 111; } && sql "insert into task (i) values ('"$i"')"; } 
! isval $dat    && isval $isnewtask && dat=$(date '+%Y-%m-%d')
! isval $tim    && isval $isnewtask && tim=$(date '+%H:%M')
! isval $remain && isval $isnewtask && remain='.123'
! isval $desc   && isval $isnewtask && desc="UNKNOWN TASK DESCRIPTION: $*"

! isval $isnewtask && { echo -n 'before: '; talist|grep '__'$i'__'|highlight; } > /tmp/tabefore 

isval $dat    && sql "update task set dat = '$dat' where i = $i"
isval $tim    && sql "update task set tim = '$tim' where i = $i"
isval $desc   && sql "update task set desc = '$desc' where i = $i"
isval $remain && sql "update task set remain = '$remain' where i = $i"

echo; echo "$*" | grep -E 'appt: ' && appt || ta #recursive  #20180404

#print which task (if update) for sanity
##! isval $isnewtask && { echo task updated: $(highlight $(sql1 "select desc from task where i = $i")); }
! isval $isnewtask && cat /tmp/tabefore
echo -n 'after:  '; talist|grep '__'$i'__'|highlight 

return #-----------------------------------------------

[ $# -eq 1 ] && {
  desc=$(sql1 'select desc   from task where i = '$1)
  sched=$(sql1 'select sched  from task where i = '$1)
  remain=$(sql1 'select remain from task where i = '$1)
  echo "update task set desc='$desc',sched='$sched',remain='$remain' where i = "$1 | clip
  return
}

# [ $# -eq 3 ] && sql "insert into task values ((select (max(i) + 1) from task),'$1','$2','$3')" ; return

[ $# -eq 4 ] && {
  sql "insert into task (i,desc,dat,tim,remain) values ( (select max(i) + 1 from task), '$1','$2','$3','$4')" 
  talist
  return
}
