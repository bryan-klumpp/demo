snapshotfile=$(btime)_MD5SUMS
md5sum "$@" | tee $snapshotfile
diffsort MD5SUMS $snapshotfile