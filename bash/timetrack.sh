cat1=$(tbare)
echo 'timetrack category before: '$cat1
timecat=$1
shift 1
#switch $timecat > /dev/null
#j timetracking "$timecat" #TODO low priority add safety so does not outrun end time switch in case of short task
tswitch $timecat
echo 'runwithblock, logging as '$timecat
"$@" #TODO some tasks not executed properly if they have complicated command lines
#t $timecat end #not doing this anymore
tswitch $cat1|tail -n 3
