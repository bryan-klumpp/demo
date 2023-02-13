[ $# -eq 0 ] && { grep -0 -E --color=always '.*'; return; }

echo -n "$@" | highlight  #recursive
