echo -n "$@" | grep -E 'IA|IL' || { echo 'must specify state'; return 28; }
scan receipt acct tax "$@"
