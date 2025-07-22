ts=$(btime)
bakfn=${HOME}/l/22/archive/"$ts"_archive_b_$"$(underscore "$*")".db
cp $(b 15) "$bakfn" && ls -l "$bakfn"|g $ts.
