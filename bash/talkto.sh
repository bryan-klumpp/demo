c 29
find | mg "$@"; return

c $(b 29)
test -f *"$*"*txt && { te *"$*"*txt; return; }
test -d *"$*"* && { c *"$*"*; return; }

bd
