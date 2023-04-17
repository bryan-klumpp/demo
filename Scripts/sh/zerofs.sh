cushionMB=200; while [[ $(df -BM --output=avail,target | grep -E " /$" | grep -oE "[0-9]+") -ge $cushionMB ]]; do dd if=/dev/zero of=big$RANDOM.zero bs=MiB status=progress count=50; done; rm *zero
