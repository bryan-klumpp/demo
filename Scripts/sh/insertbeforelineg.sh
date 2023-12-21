[ $# -eq 0 ] && { echo 'usage: insertbeforeline regexpartiallinematcher linetexttoinsert filepath'; return 1; }
matcher="$1"; insertthis="$2"; filepath="$3"
grep -q -E "$matcher" "$filepath" || { echo 'match not found, did not find '$matcher' in file '$filepath; return 1; }
tmpfilebase=/tmp/insertbeforelinetmp$RANDOM$RANDOM
grep -E -B 9999999 "$matcher" "$filepath" | head -n -1 > "$tmpfilebase"before
grep -E -A 9999999 "$matcher" "$filepath"              > "$tmpfilebase"after
{ 
    cat "$tmpfilebase"before;
    echo "$insertthis"
    cat "$tmpfilebase"after
} > "$filepath"
