 #isroot want || return
[ $# -eq 0 ] && { echo 'usage: bclamscan this is a description of scan'; return; }
logdirroot=$(b 555)
test -e $logdirroot || logdirroot=/tmp
logdir="$logdirroot"/$(btime)_$(tofilename "$*") #chg

echo 'logging to directory '$logdir #chg
mkdir "$logdir"
#sudo chown -R b "$logdir"
mkdir "$logdir/t"
mkdir "$logdir/virus_files"
sudo clamscan -varz --stdout --cross-fs=no --tempdir="$logdir/t" --follow-dir-symlinks=0 --follow-file-symlinks=0 \
   --exclude='b555_'  --copy="$logdir/virus_files" "$(pwd)" 2>&1 | tee "$logdir/stdout_and_stderr.log" 2>&1   #--exclude prevents recursive findings
clip "c $logdir"
echo 'logged to directory (clipped c): '$logdir #chg

