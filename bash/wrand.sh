while true; do {
  echo -n $(pwd) | grep wrand || return 33
  test -f z.random && mv z.random $RANDOM$RANDOM.random
  dd if=/dev/urandom bs=2M count=512 | pv -L 50M | dd of=z.random bs=1M || return 83
} done
