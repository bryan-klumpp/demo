not isval $1 && { jnlgr 'ate:' | tail -n 30; return; }
jnl 'body:ate:'$@
