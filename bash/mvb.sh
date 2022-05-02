
mvdest="$1"; shift 1
isint "$mvdest" && { test -d "$mvdest" || mvdest="$(b "$mvdest")"; }  #de-index dir if needed
test -d "$mvdest" || { echo 'missing destination dir'; return 38; }
for mvnextsrc; do {
  isint "$mvnextsrc" && mvnextsrc="$(b "$mvnextsrc")"  #de-index dir/file if needed; 2020-04-07 added quotes around first $mvnextsrc
  mv --verbose --no-clobber "$mvnextsrc" "$mvdest" || return 23
} done
a bln1 "$(can "$mvdest")";  #update /l symlinks silently and asynchronously
