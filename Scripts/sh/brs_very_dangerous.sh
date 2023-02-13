[ $# -eq 0 ] && { echo 'usage: prompt> mnt/4t /mnt/3tb/backup [dynamic_exclude_rsync_**_syntax]... [HHMM] [commit]   )' ; return; }

extflag=nocopy/nocopyexternaldriveflag.txt
from=$(can "$1"); to=$(can "$2"); shift 2
dryrun='--dry-run' ; dynamic_excludes='' ; deleteafter=''; existing=''; HM=$(echo -n $(date +%H%M))
for excl; do { 
  [[ $excl == 'commit' ]] && { dryrun=''; continue; } 
  [[ $excl == 'existing' ]] && { existing='--existing'; continue; } 
  dynamic_excludes="$dynamic_excludes"' --exclude=**'"$excl"'** '  
} done #less fancy for loop code generation - see archive
rsync -v -a $dryrun --links --hard-links --no-inc-recursive --update "$from" "$to" $dynamic_excludes  | grep -v 'ignoring unsafe symlink'
echo from: $from to: $to
not isval $dryrun && echo 'committed' 

return
####################### extra code

#sample usage brs /mnt/4t/b /mnt/3tb/backup/4t '**big**' '**.WAV' '**.mp4' '**.MP4' '**.img' '**.img.gz' '**.iso' '**.zip' '**.7z'

# no need for this if just do canonical on parameters:   co "$1" '\.' || co "$2" '\.' && { err 'file hierarchy can be corrupted by not specifying absolute directories'; return 111; }

#--exclude="**asdfasdf**" --exclude="yyyyyyyyy"

#   --exclude-from $(b 101) \
#   --info=stats1,misc1,flist2   --omit-dir-times #not sure what omit-dir-times did but we have --no-dirs?
#sudo chown -R b "$to"  #only needed if using sudo rsync above
