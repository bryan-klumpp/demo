scandir=/media/b/E/EPSCAN/001
test -d $scandir || { echo 'scan directory not ready'; return; }
finaldir="./$(btime)_$*"
mkdir "$finaldir" && cp $scandir/* "$finaldir" && find $scandir/*|xargs shred && rm $scandir/*
