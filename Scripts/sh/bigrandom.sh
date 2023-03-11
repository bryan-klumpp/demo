#useful as a quick way to semi-secure-erase a drive without blowing away the filesystem, at least on a spinning disk or a SSD where the partition in question takes up nearly all of the total space
dd if=/dev/urandom bs=MiB of=deleteme_big.random status=progress || rm deleteme_big.random
