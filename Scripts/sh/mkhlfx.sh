for next; do {
  i=$(stat --printf='%i' "$next") || exit 34
  { ln "$next" h/$i 2>/dev/null; } || true #suppress output and return code cuz might already exist
}; done



#ls -print '%i %p' | /sh/mkhlfxx.sh