if false; then {
  file=/b/credit/credit.txt
  val="$@"
  if isval $1; then true; elif contains "$val" http; then val=$(paste); else { cat $file; return; } fi
  ts=$(btime)
  echo "$ts $val" >> $file && tail $file|gg "$ts.*";
} fi

jnl '<credit>'$(paste) $@'</credit>'
