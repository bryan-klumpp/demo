while true; do {
  echo -n $(pwd) | grep zero || return 33
  test -f z.zero && mv z.zero $RANDOM$RANDOM.zero
  dd if=/dev/zero bs=2M count=4096 | pv -L 50M | dd of=z.zero bs=1M || return 83
} done
