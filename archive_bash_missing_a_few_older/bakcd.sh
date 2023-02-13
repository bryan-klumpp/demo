tdir=/t/$(btime)_CD_or_DVD_backup_burn_staging_Secure0
mkdir $tdir &&
mkdir $tdir/b100_stuff &&
cd $(b 100) &&
f|directories|tros|bxargs 'cp -d --preserve=all --parents --no-clobber --verbose --update {} '"$tdir" &&
c $tdir && echo done with bakcd
