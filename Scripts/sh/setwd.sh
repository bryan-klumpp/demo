wd=$(can $(pwd))
test -f $(b 14) || { echo -n "$wd" > /sh/b14_wd.txt && bln1 /sh; return; }
echo -n "$wd" > $(b 14)
