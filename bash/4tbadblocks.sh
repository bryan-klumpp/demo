! test -e /dev/mapper/4tclear || return 33;
badblocks -svn /dev/disk/by-partlabel/4t 2>&1 | tee /ram/4tbadblocks.log

