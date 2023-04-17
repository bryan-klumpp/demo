sudo dd if=/dev/zero of=loopy.img bs=MiB count="$1" status=progress oflag=append conv=notrunc
