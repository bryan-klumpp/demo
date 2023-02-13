[ $# -eq 0 ] && { echo 'usage: source destination [dynamic_exclude_noregex]... [HHMM] [commit]    (HHMM is my way of verifying EACH TIME that you actually want to delete what is missing in dest)' ; return; }

# no need for this if just do canonical on parameters:   co "$1" '\.' || co "$2" '\.' && { err 'file hierarchy can be corrupted by not specifying absolute directories'; return 111; }
extflag=nocopy/nocopyexternaldriveflag.txt
from=$(can "$1"); to=$(can "$2"); shift 2
dryrun='--dry-run' ; dynamic_excludes='' ; deleteafter=''; HM=$(echo -n $(date +%H%M))
for excl; do { 
  [[ $excl == 'commit' ]] && { dryrun=''; continue; } 
  [[ $excl == 'DELETE_BEFORE_CAUTION' ]] && { deleteafter='--delete-before'; continue; } 
  [ $excl -eq $HM ] && { deleteafter='--delete-before'; continue; } 
  dynamic_excludes="$dynamic_excludes"' --exclude=**'"$excl"'** ' 
} done #less fancy for loop code generation - see archive
sudo rsync -v -a $dryrun --no-dirs --update \
  "$from"/* "$to" \
  $dynamic_excludes --exclude='**nocopy**' $deleteafter | grep -v 'ignoring unsafe symlink'
#   --exclude-from $(b 101) \
#   --info=stats1,misc1,flist2   --omit-dir-times #not sure what omit-dir-times did but we have --no-dirs?
#   --links --safe-links  #too risky with new scheme of using 5tb master for everything and more syncing and using /l locally
#sudo chown -R b "$to"  #only needed if using sudo rsync above
echo from: $from to: $to
isval "$dryrun" && echo 'use '$HM' to delete missing in destination; use commit to commit'
not isval $dryrun && echo 'committed' 


###########################################################################
  # don't think info= is doing anything --info=stats2,misc1,flist0 from info doc     --relative  --files-from=FILE  --no-dirs  
  #--omit-dir-times

  #--backup --backup-dir=$backupdir


#test -f /mnt/bext/$extflag && mode='fromext' || mode='toext'
#[ mode -eq fromext && { fromdir=/b }...
#backupdirroot=/mnt/5tb/b/brsync--backup-dir
#backupdir=$backupdirroot/$(btime)
#mkdir $backupdir || { err 'problem making backup dir'; return 111; }

#echo -n '' > /t/dynamic_brsync_exclude.txt
#for excl; do echo '**'"$excl"'**' > /t/dynamic_brsync_exclude.txt; done;
