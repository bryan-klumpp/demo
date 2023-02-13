bepsonscan2 receipt "$@"


return

echo -n "$@" | grep -E 'IA|IL' || { echo 'must specify state'; return 28; }
grabcheese receipt acct tax "$@"
