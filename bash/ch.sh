isval $1 || { cat ~/.bash_history; return; }
cat ~/.bash_history | g "$@"
