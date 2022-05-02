isint $1 || { echo invalid hour value; return 111; }
sleepmin $((60 * $1))
