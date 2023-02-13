core='(backup|copy|archive|RecentDocuments|transfer|wav_masters|tmp|hardlink|sync)'
#alpha='($|[^A-Za-z])'
#grep -vE $core$alpha |
#grep -vE      $alpha$core
grep -vE "$core"