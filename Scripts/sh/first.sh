[ $# -eq 0 ] && { err 'expected at least one value'; return 111; }

for nextCandidateDir in "$@"; do { test -e "$nextCandidateDir" && { echo "$nextCandidateDir"; return; }; }; done

echo "$1"

