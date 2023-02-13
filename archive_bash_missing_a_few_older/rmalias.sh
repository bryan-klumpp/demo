rchive 'alias file before pruning' $(b 21) || return 28
cat /l/21 | grep -vE "$1"'=' > /tmp/aliases.sh
cat /tmp/aliases.sh > /l/21


#alias $key="'$*'" #"$line" #seems to have quote problem
