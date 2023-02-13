[ $# -eq 0 ] && { echo 'usage: prompt> mnt/4t /mnt/3tb/backup [dynamic_exclude_rsync_**_syntax]... [HHMM] [commit]    (HHMM is my way of verifying EACH TIME that you actually want to delete what is missing in dest)' ; return; }

extflag=nocopy/nocopyexternaldriveflag.txt
from=$(can "$1"); to=$(can "$2"); shift 2; { test -e "$from" && test -e "$to"; } || { echo 'missing from or to'; return 13; }
dryrun='--dry-run' ; dynamic_excludes='' ; deleteopt=''; existing=''; HM=$(echo -n $(date +%H%M))
for excl; do { 
  [[ $excl == 'commit' ]] && { dryrun=''; continue; } 
  [[ $excl == 'existing' ]] && { existing='--existing'; continue; } 
  is $excl '[0-9]{4}' && not is $excl $HM && { echo 'sorry try again for delete-before timestamp'; return 82; }
  is $excl $HM && { co "$to" '/media/b/4t' && { echo 'dangerous delete target'; return 12; }; deleteopt='--delete-before'; continue; }
  dynamic_excludes="$dynamic_excludes"' --exclude=**'"$excl"'** '  
} done #less fancy for loop code generation - see archive
#not using --safe-links because it causes comparison difficulties.  Just be careful.
# --inplace can cause partial files on interruption but might (with other options) enable space-saving btrfs features with snapshots later
sd rsync -v -a $dryrun --update --links --hard-links --no-inc-recursive "$from" "$to" $dynamic_excludes $deleteopt; rsret=$? | grep -v 'ignoring unsafe symlink'
echo from: $from to: $to
isval "$dryrun" && echo 'use '$HM' to delete missing in destination; use commit to commit'
not isval $dryrun && echo 'committed' 

echo 'rsync return code: '$rsret
return $rsret
####################### extra code

#move to brsd.sh
echo 'difffilelist: '; difffilelist "$1" "$2"/"$1" 
echo 'bdiff: '; bdiff "$1" "$2"/"$1" 


#sample usage brs /mnt/4t/b /mnt/3tb/backup/4t '**big**' '**.WAV' '**.mp4' '**.MP4' '**.img' '**.img.gz' '**.iso' '**.zip' '**.7z'

# no need for this if just do canonical on parameters:   co "$1" '\.' || co "$2" '\.' && { err 'file hierarchy can be corrupted by not specifying absolute directories'; return 111; }

#--exclude="**asdfasdf**" --exclude="yyyyyyyyy"

#   --exclude-from $(b 101) \
#   --info=stats1,misc1,flist2   --omit-dir-times #not sure what omit-dir-times did but we have --no-dirs?
#sudo chown -R b "$to"  #only needed if using sudo rsync above
