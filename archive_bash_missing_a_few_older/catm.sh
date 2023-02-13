f=/t/$(btime)_t.txt
echo 'text files in '$(pwd)':' > $f
sort | bxargs '
  { echo; echo "#### file: "{}" ####" ; } >> '$f'
  cat {} >>'$f
cat $f | print
